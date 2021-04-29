# Freedom Finance Quotes

Тестовый проект для компании *Freedom Finance*. Архитектура VIP, зависимости Cocoapods: 
- Starscream Websocket
- Observable - простой компонент данный паттерн
- Nuke - загрузка и отображение иконок
### Сокет
Интерфейс работы с сокетом:
```swift
protocol SocketProtocol: SocketPublisherProtocol {
    var isConnected: Bool { get }
    func open(config: Socket.Config)
    func close()
    func write(string: String)
}
```
Интерфейс событий:
```swift
enum Socket {
    enum Event {
        case onInitialized
        case onDataReceived(data: Data)
    }

    enum Status {
        case onInitialized
        case onConnected
        case onDisconnected
    }
    ...
protocol SocketPublisherProtocol {
    var events: Observable<Socket.Event> { get }
}
protocol SocketStatusProvider {
    var status: Observable<Socket.Status> { get }
    var isConnected: Bool { get }
}
```
`WebSocketImpl` - реализация посредством компонента `Starscream`.
### Сетевой слой
`SocketManager` - отвечает за открытие/закрытие сокета, переподключение при обрыве.
```swift
protocol SocketManagerProtocol {
    func start(config: Socket.Config)
    func pause()
    func restore()
    func stop()
}
```
`NetworkStatusProvider` - синхронное получение состояние сети
`SocketCommandSenderProtocol` - отправка команд в сокет
```swift
protocol SocketCommand {
    var id: String { get }
    var isRestorable: Bool { get }
    var toJson: String { get }
}
```
Если команда поддерживает состояние `isRestorable`, то при переподключении сокета она будет отправлена в сокет заново посредством `SocketInitializerProtocol`. Этот механизм позволяет не заботится о состоянии сокета `open/close`. Механизм работает по принципу вытеснения, те команда с одним и тем же id, перезаписывается. Порядок команд не сохраняется.
### Модели данных
Данные приходящие из сокета описываются моделью:
```swift
enum SocketResponse {

    enum DataType: String, Codable {
        case userData = "userData"
        case quote = "q"
    }

    case userData(model: UserDataResponseModel)
    case quote(model: QuoteResponseModel)
}
```
Преобразование данных из сокета `Data` в `SocketResponse` присходит посредством парсера `SocketParserProtocol` и `SocketResponseFactoryProtocol `.

Domain модели: 
`QuoteModel` - умеет создаваться из `QuoteResponseModel` и своего предыдущего состояния.
Вспомогательные: `Sign`, `Direction`.

### Хранилища данных

Для хранения котировок применяем in-memory thread-safe сторадж:
```swift
protocol QuotesStorageProtocol {
    func getAll() -> [QuoteModel]
    func getById(tickerId: String) -> QuoteModel?
    func removeAll()
    func update(items: [QuoteResponseModel], completion: @escaping (_ updated: QuotesStorageUpdated) -> Void)
}
```
Умеет обновлять данные и отдавать результат в виде:
```swift
struct QuotesStorageUpdated {
    let inserted: Set<QuoteModel>
    let updated: Set<QuoteModel>
}
```
Это удобно для последующего использования в UI.
### Репозитории
Работа с котировками осуществляется через:
```swift
protocol QuotesRepositoryProtocol {
    var events: Observable<QuotesRepositoryEvent> { get }
    func subscribe(tickers: [String])
    func getAll() -> [QuoteModel]
    func removeAll()
}
```
### Потоковая модель
Основная идея как можно больше логики делать в background. Flow данных можно представить:
- Socket [socket-dispatch-queue]
- Parsers [socket-dispatch-queue]
- Storage [storag-dispatch-queue]
- Repository [repository-dispatch-queue] 
- Module Interactor [repository-dispatch-queue] 
- Presenter обработка в [repository-dispatch-queue] и отправка готовых данных на **Main thread**
- UI

### DI
В проекте использован паттерн `Service Locator`: `ServiceLocatorProtocol` и `ModuleLocatorProtocol`. Зависимости передаются через конструкторы.
### Модули
Однонаправленная архитектура VIP (Slean Swift)
![Vip](https://habrastorage.org/webt/xf/kt/ti/xfkttir6l7nud2q-m8ptw_1kfl8.jpeg)
Модель обновления view:
```swift
enum QuotesModuleViewState {
    case initial
    case update(viewModel: QuotesModuleViewModel)
    case emptyResult(message: String)
    case networkError(message: String)
}
...
struct QuotesModuleViewModel {
    let items: [QuoteViewModel]
    let updatedIndexes: Set<Int>
}

```
`updatedIndexes` содержит номера обновленных элементов.

### UI
Все цвета и шрифты задаются через палитру:

```swift
protocol PaletteProtocol {
    func getFont(_ size: Palette.FontSize) -> UIFont
    func getMediumFont(_ size: Palette.FontSize) -> UIFont
    func getColor(_ color: Palette.Color) -> UIColor
}
```
Это позволяет легко поддерживать темы, рефакторить цвета и делать light/dark интерфейс. Расположение элементов, цвета взяты из оригинального приложения. Набросал дизайн в Sketch `Design.sketch`.

`PaddingLabel` - компонент отображения текста + бейджа.
Отображение иконок тикеров сделано через библиотеку `Nuke`.

Эффект *вспышки* при обновлении реализован в `QuotesModuleViewQuoteCell`, мы понимаем, что ячейка находится в списке `updatedIndexes` и запускаем анимацию.

![Screen](https://github.com/mirovodin/FFQuotes/blob/060f0266f9e7a4e24f8151c994f450beb136b944/Docs/screen.png?raw=true)

### Что реализовано плохо или не реализовано
- Нужно реализовать Mock на репозиторий, тк хочется более быстрое обновление котировок
- Сейчас очень *криво* передается url иконок во viewModel
- Вычисление индексов, какие элементы обновлены происходит не оптимально
- Сделать Landscape режим

