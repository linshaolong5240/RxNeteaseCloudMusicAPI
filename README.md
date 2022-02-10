# RxNeteaseCloudMusicAPI

NeteaseCloudMusicAPI RxSwift Extension

## Usage:
```Swift
//RxSwift 6.0.0+
NCM.requestObserver(action: NCMPlaylistDetailAction(id: id)).subscribe { response in
    print(response)
} onFailure: { error in
    print(error)
} onDisposed: {

}.disposed(by: disposeBag)
```
