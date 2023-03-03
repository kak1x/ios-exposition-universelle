# iOS 커리어 스타터 캠프
# 🇰🇷🇫🇷 만국박람회

> 프로젝트 기간: 2023.02.20 ~ 2023.03.03
> 
> 팀원: 👨🏻‍💻[kaki](https://github.com/kak1x), 👨🏻‍💻[brody](https://github.com/seunghyunCheon) | 리뷰어: 👨🏻‍💻[havi](https://github.com/havilog)
> 
> 만국박람회 앱 구현


## 목차
1. [타임라인](#-타임라인)
2. [프로젝트 구조](#-프로젝트-구조)
3. [실행 화면](#-실행-화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [참고 링크](#참고-링크)

<br/>

# ⏰ 타임라인
<details>
    <summary><big>타임라인</big></summary>
- 23.02.20 (월): JSON Data Model 구조체 구현 (STEP1 PR)
<br>
- 23.02.21 (화): STEP1 리뷰 사항 수정 (refactor) 및 첫번째, 두번째 뷰컨트롤러 구현
<br>
- 22.02.22 (수): 세번째 뷰컨트롤러 구현 (STEP2 PR)
<br>
- 22.02.23 (목): STEP2 리뷰 사항 수정 (화면 전환 방식 변경, 확장 및 프로토콜 추가)
<br>
- 22.02.24 (금) : STEP2 리뷰 사항 수정 (커스텀셀 XIB 생성, refactor)
<br>
- 22.02.27 (월) : STEP2 리뷰 사항 수정 (셀 configure 함수 생성, prepareForReuse 구현 및 refactor)
<br>
- 22.02.28 (화) : STEP2 리뷰 사항 수정 (String extension attributedString fileprivate 선언), , STEP3 구현 (오토레이아웃, Dynamic Type, Accessibility)
<br>
- 22.03.02 (목) : STEP3 리뷰 사항 수정 (셀 image 오토레이아웃 변경)
</details>
<br/>
<br/>
    
# ✍🏻 프로젝트 구조
<details>
    <summary><big>폴더구조</big></summary>
<img src = "https://i.imgur.com/gT1cihK.png">
    </details>

<details>
    <summary><big>프로젝트 UML</big></summary>
<img src = "https://i.imgur.com/WV6DVcQ.png">
    </details>
    
<br/>
<br/>

# ✨ 실행 화면

### 다이나믹 타입 미적용 화면
|초기화면|출품작 페이지 이동|출품작 상세페이지 이동|
|:-----:|:-----:|:-----:|
| <img src = "https://i.imgur.com/NQzeTpE.gif" width = "300">|<img src = "https://i.imgur.com/KCYXGIt.gif" width = "300">  |<img src = "https://i.imgur.com/iCsvAAN.gif" width = "300">|

### 다이나믹 타입 적용 화면
|초기화면|출품작 페이지 이동|출품작 상세페이지 이동|
|:---:|:----:|:----:|
|<img src="https://i.imgur.com/oYqgYzu.gif" width = "300"/>|<img src="https://i.imgur.com/GqhGYza.gif" width = "300"/>|<img src="https://i.imgur.com/mo7D8pC.gif" width = "300"/>|

<br/>
<br/>

# 🔥 트러블 슈팅
### 1. JSON Decoder 공통 부분 재사용화
- 두 개의 뷰 컨트롤러에서 JSON을 Decoder하는 함수를 사용해 중복 코드가 발생했습니다.

### ⚒️ 해결방법
- JSONDecoder를 extension하여 새로운 함수를 정의해 매개변수로 `Decode`할 타입만 넣어서 중복코드를 제거했습니다.
```swift
extension JSONDecoder {
    func loadJSONData<T: Decodable>(name: String, type: T.Type) throws -> T {
        guard let dataAsset = NSDataAsset(name: name) else {
            throw DataAssetError.invalidFileName
        }
        
        do {
            let data = try self.decode(type, from: dataAsset.data)
            
            return data
        } catch {
            throw error
        }
    }
}
```

### 2. ItemDetailViewController Custom Initiallizer 사용
- 기존에는 셀을 클릭할 때 `ItemDetailViewController`를 생성한 후에 내부 프로퍼티에 접근해 데이터를 주입했습니다.
- 하지만 해당 방법은 프로퍼티에 데이터를 제공하는 코드가 없어도 화면이 이동된다는 점에서 휴먼에러가 발생할 수 있다는 단점이 존재했습니다.
### ⚒️ 해결방법
```swift
// ItemDetailViewController
private let item: ExpositionUniverselleItem

init?(item: ExpositionUniverselleItem, coder: NSCoder) {
    self.item = item
    super.init(coder: coder)
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

// KoreaItemsViewController
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if let itemDetailVC = storyboard?.instantiateViewController(identifier: "ItemDetailViewController", creator: { creator in
        let item = self.expositionItems[indexPath.row]
        let viewController = ItemDetailViewController(item: item, coder: creator)
        return viewController
    }) {
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}
```

### 3. Custom Cell XIB 구현 및 Regeister
- 애플의 기본셀을 최대한 활용해서 만들어보려고 했으나 이는 오토레이아웃을 직접 잡을 수 없어 디테일한 제약을 줄 수 없었습니다.
- 그리고 메인 스토리보드 내 하나의 뷰 컨트롤러에서 기본 셀이 아닌 커스텀 셀을 사용한다면 따로 Nib파일로 분리하여 유지보수를 높이는 것이 좋다고 생각했습니다.
### ⚒️ 해결방법
<img src = "https://i.imgur.com/U5ZHiSD.png" width = 400>

- Xib파일과 Xib파일과 연결된 커스텀 셀파일을 만든 뒤 연결시켜주었습니다. 
```swift
// KoreaItemsViewController
private func registerXib() {
    let nibName = UINib(nibName: "ExpositionTableViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: ExpositionTableViewCell.reuseIdentifier)
}
```
- Xib파일은 현재 테이블뷰에 등록되어있지 않기 때문에 등록해주는 코드를 작성했습니다.


### 4. Custom Cell ReuseIdentifier
- 셀이 재사용되기 위해서는 반드시 `reuseIdentifier`를 가지는 것이 좋다고 생각이 들었습니다.
### ⚒️ 해결방법
```swift
protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// ExpositionTableViewCell
extension ExpositionTableViewCell: ReuseIdentifying { }
```
- `ReuseIdentifying`프로토콜을 정의하여 커스텀 셀에서 이를 준수하도록 만들었습니다. 
- 프로토콜 확장을 이용해 이 프로토콜을 채택하는 셀 타입이 해당 프로퍼티를 정의하지 않고 기본값을 가질 수 있도록 만들었습니다. 

### 5. Custom Cell AutomaticDimension 사용
- Custom Cell의 height가 기본값으로 고정되어 있어 셀이 잘리는 현상이 발생하였습니다.
- automaticDimension 프로퍼티를 사용하여 TableViewDelegate에 적용하였는데도 아무것도 바뀌지 않았는데, 이는 Custom Cell 내부 UI의 상, 하, 좌, 우 constraint를 지정해주지 않아 크기를 계산할 수 없기 때문에 발생한 문제였습니다.

### ⚒️ 해결방법
<img src = "https://i.imgur.com/D1pzqxR.png" width = 500>

- Custom Cell 내부의 UI들을 StackView로 묶어준 다음 StackView의 상, 하, 좌, 우 제약 조건을 설정해주었습니다.

```swift
// KoreaItemsViewController
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}
```
- TableViewDelegate에 정의되어있는 `heightForRowAt` 메서드를 사용하여 셀의 높이를 자동으로 변경해줄 수 있었습니다.
<br/>
<br/>

# 참고 링크
* [Apple Developer Documentation - UITableView](https://developer.apple.com/documentation/uikit/uitableview)
* [Apple Article - Filling a table with data](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/filling_a_table_with_data)
* [Apple Article - Using JSON with Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/using_json_with_custom_types)
* [WWDC - Accessibility Insepector](https://developer.apple.com/videos/play/wwdc2019/257/)
* [WWDC - Writing Great Accessibility Label](https://developer.apple.com/videos/play/wwdc2019/254/)
* [iOS :: TableView xib로 구현하기](https://shark-sea.kr/entry/iOS-TableView-xib로-구현하기)
* [UIViewController 서브클래스의 custom initializer 만들기](https://velog.io/@dev_jane/UIViewController-서브클래스의-custom-initializer-만들기required-initializer-initcoder-must-be-provided-by-subclass-of-UIViewController)
* [dynamic tableView cell height](https://arcjeen.tistory.com/15)
* [why UITableViewAutomaticDimension not working? - stackoverflow](https://stackoverflow.com/questions/30299319/why-uitableviewautomaticdimension-not-working)
* [Nicer reuse identifiers with protocols in Swift](https://medium.com/bleeding-edge/nicer-reuse-identifiers-with-protocols-in-swift-97d18de1b2df)
