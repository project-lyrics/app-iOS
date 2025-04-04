# Feelin - 모두의 이야기로 채우는 우리의 음악 공간
[![swift](https://img.shields.io/badge/swift-5.10-orange)]()[![xcode](https://img.shields.io/badge/Xcode-15.4-blue)]() [![tuist](https://img.shields.io/badge/Tuist-4.17.0-purple)]()[![Kingfisher](https://img.shields.io/badge/Kingfisher-7.12.0-green)]()[![FlexLayout](https://img.shields.io/badge/FlexLayout-2.0.10-yellow)]()[![PinLayout](https://img.shields.io/badge/PinLayout-1.10.5-black)]()

`2024.02 ~ Now`

### 

![앱스토어 이미지](https://github.com/user-attachments/assets/6dc8b1a0-6170-4e2a-a1e7-c4bf94207774)

- [앱스토어에서 다운 받기](https://apps.apple.com/kr/app/sopt/id6738319829)

---

## 목차
- [프로젝트 개요](#프로젝트-개요)
- [사용한 기술](#사용한-기술)
- [앱 버전 히스토리](#📱-App-Version)
- [설계 과정](#🏡-설계-과정)
  - [1. 서비스의 본질 파악](#1-서비스의-본질-파악)
  - [2. 아키텍처 선정](#2-아키텍처-선정)
  - [3. 설계 KeyPoints](#3-설계-KeyPoints)
    - [모듈화](#Modular-Architecture)
    - [코디네이터 패턴](#Coordinator)
    - [의존성 주입](#Dependency-Injection)
    - [단위 테스트](#Unit-Test)


## 프로젝트 개요
Feelin은 음악 가사에 대한 자신의 생각과 감정을 공유하는 iOS 앱입니다. 사용자들은 좋아하는 아티스트의 노래 가사에 관한 자신만의 해석이나 감정을 노트 형태로 작성하고 공유할 수 있습니다. 또한 다른 사용자들의 노트에 좋아요, 댓글을 남기거나 북마크할 수 있습니다.

## 사용한 기술
- **아키텍처**: CleanArchitecture + MVVM
- **모듈화**: Tuist
- **UI**: FlexLayout, PinLayout
- **Network**: Combine, Kingfisher
- **로그인**: 소셜 로그인 (카카오, 애플로그인)

## Tuist 의존성 그래프 

![graph](https://hackmd.io/_uploads/H1IiC2qpJg.png)
<details>
<summary>구조도</summary>

```
├── Projects
│   ├── App
│   ├── Coordinator
│   │   ├── App
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       └── Root
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Home
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Main
│   │   │   └── Derived
│   │   │       └── InfoPlists
│   │   ├── MyPage
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Onboarding
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── SearchNote
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Sources
│   │   └── TabBar
│   │       ├── Derived
│   │       │   └── InfoPlists
│   │       ├── Interface
│   │       │   └── Sources
│   │       ├── Sources
│   │       ├── Testing
│   │       │   └── Sources
│   │       └── Tests
│   │           └── Sources
│   ├── Core
│   │   ├── LocalStorage
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Example
│   │   │   │   └── Sources
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Error
│   │   │   │       └── StorageInterface
│   │   │   └── Sources
│   │   │       └── Storage
│   │   ├── Network
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── API
│   │   │   │       ├── DTO
│   │   │   │       │   ├── Request
│   │   │   │       │   └── Response
│   │   │   │       ├── EndPoint
│   │   │   │       └── Error
│   │   │   ├── Sources
│   │   │   │   ├── EndPoint
│   │   │   │   └── Extensions
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   └── Sources
│   ├── DependencyInjection
│   │   └── Sources
│   │       └── DIContainer
│   │           └── Inject
│   ├── Domain
│   │   ├── Artist
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Errors
│   │   │   │       ├── Services
│   │   │   │       └── UseCase
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Derived
│   │   │   └── InfoPlists
│   │   ├── Note
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Errors
│   │   │   │       ├── Model
│   │   │   │       ├── Models
│   │   │   │       ├── Services
│   │   │   │       └── UseCases
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Notification
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Errors
│   │   │   │       ├── Models
│   │   │   │       ├── Services
│   │   │   │       └── UseCases
│   │   │   ├── Sources
│   │   │   │   └── NotificationRoot
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── OAuth
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Error
│   │   │   │       ├── Helpers
│   │   │   │       ├── Model
│   │   │   │       ├── Service
│   │   │   │       └── UseCase
│   │   │   ├── Sources
│   │   │   │   └── Service
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── PostTextUseCase
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   ├── Report
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Errors
│   │   │   │       ├── Model
│   │   │   │       ├── Services
│   │   │   │       └── UseCases
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Shared
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Errors
│   │   │   │       ├── Models
│   │   │   │       ├── Protocols
│   │   │   │       ├── Services
│   │   │   │       └── UseCasess
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Sources
│   │   ├── Tests
│   │   │   └── Sources
│   │   └── UserProfile
│   │       ├── Derived
│   │       │   └── InfoPlists
│   │       ├── Interface
│   │       │   └── Sources
│   │       │       ├── Errors
│   │       │       ├── Models
│   │       │       ├── Services
│   │       │       └── UseCase
│   │       ├── Sources
│   │       ├── Testing
│   │       │   └── Sources
│   │       └── Tests
│   │           └── Sources
│   ├── Feature
│   │   ├── Home
│   │   │   ├── Derived
│   │   │   │   ├── InfoPlists
│   │   │   │   └── Sources
│   │   │   ├── Example
│   │   │   │   └── Sources
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Errors
│   │   │   │       ├── Models
│   │   │   │       ├── Protocols
│   │   │   │       ├── ViewControllers
│   │   │   │       │   ├── Note
│   │   │   │       │   ├── Notification
│   │   │   │       │   ├── UserLink
│   │   │   │       │   └── WritingNote
│   │   │   │       ├── ViewModels
│   │   │   │       │   └── Notification
│   │   │   │       └── Views
│   │   │   │           ├── Cells+SupplementaryViews
│   │   │   │           ├── Components
│   │   │   │           ├── Report
│   │   │   │           ├── SearchNote
│   │   │   │           ├── UserLink
│   │   │   │           └── WritingNote
│   │   │   ├── Sources
│   │   │   │   └── HomeRoot
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Main
│   │   │   ├── Derived
│   │   │   │   ├── InfoPlists
│   │   │   │   └── Sources
│   │   │   ├── Example
│   │   │   │   └── Resources
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   └── Sources
│   │   ├── MyPage
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Example
│   │   │   │   ├── Resources
│   │   │   │   └── Sources
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Models
│   │   │   │       ├── ViewControllers
│   │   │   │       │   └── PageControl
│   │   │   │       ├── ViewModels
│   │   │   │       └── Views
│   │   │   │           └── Cells
│   │   │   ├── Sources
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   ├── Onboarding
│   │   │   ├── Derived
│   │   │   │   └── InfoPlists
│   │   │   ├── Example
│   │   │   │   └── Sources
│   │   │   ├── Interface
│   │   │   │   └── Sources
│   │   │   │       ├── Components
│   │   │   │       │   ├── Login
│   │   │   │       │   ├── Profile
│   │   │   │       │   └── UserAgreement
│   │   │   │       ├── Models
│   │   │   │       ├── ViewControllers
│   │   │   │       └── ViewModel
│   │   │   ├── Sources
│   │   │   │   └── OnboardingRoot
│   │   │   ├── Testing
│   │   │   │   └── Sources
│   │   │   └── Tests
│   │   │       └── Sources
│   │   └── Sources
│   ├── LayoutUtil
│   │   ├── Derived
│   │   │   └── InfoPlists
│   │   └── Sources
│   └── Shared
│       ├── DesignSystem
│       │   ├── Derived
│       │   │   ├── InfoPlists
│       │   │   └── Sources
│       │   ├── Resources
│       │   └── Sources
│       │       ├── Buttons
│       │       ├── Cells
│       │       ├── Extensions
│       │       ├── Models
│       │       ├── ViewControllers
│       │       └── Views
│       │           └── FeelinPagerTabStrip
│       ├── Sources
│       ├── ThirdPartyLib
│       └── Util
│           ├── Derived
│           │   └── InfoPlists
│           ├── Sources
│           │   ├── CombineCocoa
│           │   ├── Errors
│           │   ├── Extensions
│           │   │   └── Combine
│           │   ├── Keychain
│           │   │   └── Model
│           │   ├── Logger
│           │   ├── Models
│           │   ├── Preview
│           │   └── ViewControllers
│           ├── Tests
│           │   └── Sources
│           └── Util.xcodeproj

```
</details>

## 📱 App Version

| 날짜  | 버전     |
| :---- | :------- |
| 24.12 | `v1.0.0` |
| 25.01 | `v1.0.1` |
| 25.01 | `v1.0.2` |
| 25.04 | `v1.0.3` |

## 🏡 설계 과정

### 1. 서비스의 본질 파악
<details>
<summary>기획서 요구사항 분석</summary>

기획서가 완전하게 확정되지 않은 상황에서도, 다음과 같은 본질적 요구사항을 확인했다:

- 모든 화면에서 회원/비회원 여부와 토큰 만료 상태를 일관되게 처리해야 함
- 로그인/회원가입/자동로그인/딥링크 등 다양한 화면 전환 플로우가 존재
- 노트 작성·수정·삭제, 음악 플레이어 등 재사용되는 컴포넌트가 많음
- 여러 명이 병렬로 개발하기 좋은 구조가 필요
</details>

### 2. 아키텍처 선정

<details>
<summary>아키텍처 검토 및 선정 과정</summary>
<img width="1642" alt="스크린샷 2025-01-30 16 50 44" src="https://github.com/user-attachments/assets/e8dedd75-317a-45e9-8a4e-79bd723507b7" />

> 하루종일 고민한 흔적


처음에는 Clean Swift를 검토했지만, 실제 프로젝트 요구사항과 맞지 않는 부분이 많았다.

**Clean Swift의 한계**

- Router는 화면 단위 네비게이션만 담당 → 앱 전체 플로우를 관리하는 구조 부재
- SceneDelegate/AppDelegate에서 rootViewController를 직접 교체하는 방식은 유지보수성 저하, 상위-하위 모듈 간 의존성 증가
- PopToViewController 방식은 화면 수 증가 시 관리 복잡도 급증
- Storyboard 기반 예제가 많아, 코드 기반 UI 구성과 궁합이 나쁨

결과적으로, Clean Swift는 프로젝트를 위한 선택이 아닌, 아키텍처에 프로젝트를 끼워 맞추는 모양새가 됨.

#### 최종 결론 - MVVM-C 기반 Clean Architecture

**선택 이유**

1. 네비게이션 중앙 관리
   - Coordinator가 모든 플로우를 통합 관리하고, 각 화면은 자신의 로직에만 집중
   - Parent-Child 구조로 복잡한 플로우도 유연하게 처리 가능

2. 명확한 책임 분리
   - 화면 전환 책임은 Coordinator가, 화면 로직은 ViewModel이 담당
   - SceneDelegate, AppDelegate 의존 제거로 유지보수성 향상

3. 테스트 용이성 강화
   - ViewModel은 UI와 분리되어 단위 테스트 용이
   - Coordinator 역시 네비게이션 흐름을 독립적으로 테스트 가능

4. 유연한 확장성
   - 신규 플로우 추가 시 기존 구조 변경 없이 새로운 Coordinator만 추가하면 됨
   - 화면 재사용도 쉬워져 개발 효율성 증가

5. 성능과 리소스 관리 최적화
   - NavigationController 재생성 없이 플로우 전환 가능
   - 메모리 릴리즈 시점도 명확해져 메모리 관리에도 유리

#### 구조적 기대 효과

- 플로우 변경 요구에도 중앙 Coordinator만 수정하면 대응 가능
- 재사용성 높은 화면은 어디서든 동일 패턴으로 호출 가능
- 에러 핸들링도 Coordinator에서 일괄 처리해 일관성 확보
- Clean Architecture 기반으로 계층 간 역할과 의존성 명확
</details>

### 3. 설계 KeyPoints

#### Modular Architecture

<details>
<summary>모듈화 전략 및 Tuist 도입 배경</summary>

**모듈화의 필요성**

프로젝트 초기부터 다음과 같은 이유로 모듈화가 필수적이라 판단했다

클린 아키텍처 실현

- 클린 아키텍처에서 각 레이어는 명확하게 책임이 분리되어야 함
- 폴더 구분만으로는 레이어 간 명확한 경계를 유지하기 어려움
- 모듈 단위로 레이어를 분리하면, 각 레이어의 독립성과 책임 분리가 확실해지고, 불필요한 상위-하위 의존성도 제거 가능

서비스 확장성 대비

- 초기 MVP 이후 유저 반응에 따라 지속적인 기능 추가가 예상됨
- 하나의 모듈에 모든 기능이 담기면, 파일이 급격히 많아지고, 빌드 시간 증가 및 생산성 저하로 이어질 가능성 있음
- 기능별, 도메인별 모듈화로 확장성을 확보하고, 빌드 최적화까지 고려

빠른 개발 및 디버깅

- 데모 앱이나 각 모듈 단위 테스트용 AppTarget 구성도 용이해져, 빠른 기능 개발 및 디버깅 환경 구성에 유리

**모듈화 도구로 Tuist 선택 이유**

코드 기반 프로젝트 관리

- 각 모듈 단위 설정, App 설정을 코드로 관리 가능
- 프로젝트 구조 변경 시에도 .xcodeproj 충돌 없이 안정적으로 관리 가능

의존성 시각화 및 관리

- tuist graph 기능을 통해 모듈 간 의존성을 한눈에 파악 가능
- 의존성 사이클이나 불필요한 의존성 유입을 사전에 방지

빌드 단계에서 상호 참조 체크

- 모듈 간 의존성 규칙을 Tuist 레벨에서 강제할 수 있어, 예상치 못한 상위-하위 모듈 간 의존성 꼬임 방지

생산성 도구 활용

- Makefile, Tuist Template 등을 활용해 각 모듈별 필요 파일 및 템플릿을 자동 생성 가능
- 신규 모듈 추가 시 일관된 구조로 빠르게 구성 가능

**기대 효과**

- 기능 추가 시 필요한 모듈만 수정 → 빌드 시간 단축
- 레이어 간 의존성 명확 → 유지보수성 및 테스트 용이성 강화
- 서비스 확장에도 아키텍처 전체를 건드리지 않고, 독립적으로 기능 추가 가능
- 신규 참여자 온보딩 시 전체 구조 이해도 ↑
</details>

#### Coordinator

<details>
<summary>Coordinator 패턴 적용</summary>

**문제 상황**

- 로그인 이후 특정 위치로 이동하거나, 딥링크로 특정 화면에 진입하는 플로우가 존재
- 비회원이 특정 기능을 실행하다가 로그인 후 다시 해당 기능을 이어가는 흐름이 필요
- 중복 로그인/토큰 만료 같은 글로벌 이벤트 발생 시에도 일괄적인 화면 전환이 필요

**원인 분석**

- Clean Swift의 Router는 개별 화면 단위에서만 동작
- 앱 전체의 플로우를 관리하는 AppRouter 같은 개념이 부재
- SceneDelegate/AppDelegate에서 rootViewController를 직접 변경하는 방식은 유지보수성 저하 및 의도치 않은 사이드 이펙트 가능성 존재

**선택한 방법**

- 화면 전환 흐름을 중앙 Coordinator에서 일괄 관리
- 각 화면은 자신의 로직과 UI에만 집중하고, 네비게이션 흐름은 Coordinator에게 위임
- 화면 간 데이터 전달도 Coordinator가 담당하여, 화면의 독립성 유지

**기대 효과**

- 각 화면이 자신의 역할에만 집중 → 단일 책임 원칙 강화
- 복잡한 네비게이션 플로우도 단일 진입점에서 관리 → 유지보수성 개선
- 글로벌 이벤트 발생 시에도 Coordinator에서 전체 플로우를 제어 → 일관성 유지

**실제 효과**

- 화면 전환 흐름이 명확해지고, Flow 변경 시에도 Coordinator만 수정하면 되는 구조 확보
- 재사용성이 높은 화면은 다른 Coordinator에서도 동일한 방식으로 호출 가능 → 중복 로직 감소
- Alert, 팝업 같은 공통 UI 처리도 중앙 Coordinator에서 통합 관리
</details>

#### Dependency Injection

<details>
<summary>의존성 주입 전략 및 구현</summary>

**문제 상황**

- 화면 생성 시마다 필요한 네트워크 서비스, 유틸리티 객체 등을 직접 생성
- 각 화면마다 중복 코드 발생, 생성 방식이 조금씩 달라지는 문제
- 테스트 시에도 실제 서비스 객체를 직접 주입해야 해서, 테스트가 어려움

**원인 분석**

- 네트워크 레이어 및 유틸리티 객체 생성 책임이 화면 쪽에 존재
- 화면별로 필요한 의존성 리스트가 다르다 보니, 화면마다 생성 로직이 달라짐
- Mock 주입 같은 테스트 유연성 확보가 어려움

**선택한 방법**

- DIContainer를 만들어 각종 의존성을 컨테이너에 등록하고, 필요할 때 꺼내쓰는 구조로 변경
- 화면에서는 필요한 의존성만 주입받고, 직접 생성하지 않도록 수정
- 공통 의존성은 @Injected 같은 프로퍼티 래퍼로 간단하게 주입받을 수 있도록 구성

**기대 효과**

- 화면의 생성 책임 분리 → 단일 책임 원칙 강화
- 테스트 시 Mock 객체 주입 가능 → 테스트 용이성 향상
- 의존성 관리 일원화 → 생성 방식의 일관성 유지 및 중복 코드 제거

**실제 효과**

- 의존성 관리 포인트가 단일화되어, 신규 서비스 추가/교체가 간편해짐
- 의존성 주입 패턴이 통일되어, 코드 가독성 향상
- 네트워크 테스트 등에서도 실제 객체 대신 Mock 객체 주입 가능 → 테스트 커버리지 확장

결과적으로 의존성 관리와 객체 생성 책임을 화면에서 분리하고, 모듈 간 결합도도 낮추는 효과를 얻었다.
</details>

#### Unit Test

<details>
<summary>테스트 전략 및 구현</summary>

**문제 상황**

- 네트워크 요청 성공/실패 여부만 테스트하면 충분하지 않음
- 토큰 만료, 데이터 파싱 실패 등 다양한 에러 케이스가 존재
- 외부 환경 변화에 따른 동작 보장을 위해 정교한 테스트 필요

**원인 분석**

- 네트워크 레이어가 URLSession에 직접 의존
- 실제 요청을 보내야만 테스트가 가능해, 네트워크 상황에 따라 테스트 결과가 달라지는 문제
- 네트워크 레이어의 인터페이스와 구현이 분리되지 않아, Mock 구성 어려움

**선택한 방법**

- POP(Protocol Oriented Programming) 기반으로 네트워크 레이어 구성
- 네트워크 요청 인터페이스를 프로토콜로 정의하고, 실제 구현과 Mock 구현을 분리
- 테스트 시 Mock 네트워크 객체를 주입하여, 원하는 응답과 에러를 시뮬레이션

**기대 효과**

- 네트워크 환경에 영향을 받지 않고, 다양한 케이스에 대한 테스트 가능
- 서비스 레이어도 실제 네트워크 구현체가 아닌 프로토콜에 의존 → 테스트 유연성 극대화
- 에러 처리 로직의 안정성 확보

**실제 효과**

- 예상 가능한 대부분의 에러 시나리오 테스트 완료
- 신규 API 추가 시에도 동일한 패턴으로 테스트 코드 작성 가능 → 테스트 패턴 정립
- 네트워크 레이어 신뢰성 강화 → 클라이언트 레이어 로직도 간접적으로 검증 가능
</details>