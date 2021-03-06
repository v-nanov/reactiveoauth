import Alamofire
import ReactiveSwift
import Result

extension DataRequest: ReactiveExtensionsProvider
{
}

extension Reactive where Base: DataRequest
{
    public var responded: Signal<Data, AnyError> {
        typealias Pipe = (output: Signal<Data, AnyError>, input: Observer<Data, AnyError>)
        let pipe: Pipe = Signal<Data, AnyError>.pipe()

        self.base.response(completionHandler: {
            if let data: Data = $0.data {
                pipe.input.send(value: data)
            } else if let error: Swift.Error = $0.error {
                pipe.input.send(error: AnyError(error))
            }
            pipe.input.sendCompleted()
        })

        return pipe.output
    }
}