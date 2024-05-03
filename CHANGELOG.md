Ensemble Movies ChangeLog
===============

## Version Summary
<details>
<summary><strong>v1.X</strong> </summary>

- [1.0.0](#v100)
</details>

<details>
<summary><strong>v0.X</strong> </summary>

- [0.14.0](#v0140)
- [0.13.0](#v0130)
- [0.12.2](#v0120)
- [0.11.2](#v0112)
- [0.11.1](#v0111)
- [0.11.0](#v0110)
- [0.10.0](#v0100)
- [0.9.0](#v090)
- [0.8.0](#v080)
- [0.7.0](#v070)
- [0.6.0](#v060)
- [0.5.0](#v050)
- [0.4.0](#v040)
- [0.3.0](#v030)
- [0.2.0](#v020)
- [0.1.x](#v01x)
</details>

---
---
---

## v1.0.0
> May 02, 2024

 ### [v1.0.0-b1](https://github.com/LucasCBarros/EnsembleMoviesOMDB/tree/v1.0.0.b1)
### Added
Added app logo and splashScreen

---

---

## v0.14.0
> May 02, 2024
### Added
Adding UITests for MovieSearchList and MovieDetails 
Adding AccessibilityLabels to find elements in UITests

## v0.13.0 
> May 02, 2024
### Added
Adding extensions as Swift Package

## v0.12.0
> May 02, 2024
### Added
Adding UI test for MovieSearchListViewController + computed property in FetchError


## v0.11.2
> May 02, 2024

### [stable-v1.0.0](https://github.com/LucasCBarros/EnsembleMoviesOMDB/tree/Stable-v1.0.0)
### Fixed 
- Fixing "missing files" error because MovieSearchListViewModelTests.swift was deleted without adding to project + updating files that weren't versioned


## v0.11.1
> May 02, 2024
### Fixed
- WARNING: Just found out these files were not being versioned because they were somehow saved in Documents file
I don't know what happened but might impact the project from running previous versions

## v0.11.0 
> May 02, 2024
### Branched [feature/NetworkManagerAsync]
Fixing AsyncAwait branch with missing files
Moved all calls to the NetworkManagerAsyncAwait + TODO: fiz a few UnitTests that broke

## v0.10.0 
> May 02, 2024
### Added
Movie & Search JSON to mock tests + NetworkManagerTests (Created an Async/Await option too) + Started UI tests

## v0.9.0 
> May 01, 2024
### Added
Created MovieSearchListViewControllerTests
MovieSearchListViewModelTests

## v0.8.0
> May 01, 2024
### Added
Removed NetwrokManager singleton
Removed unused extensions + Created NetworkManagerMock for testing + MovieDetailViewModel tests + MovieDetailViewControllerTests

## v0.7.0 
> May 01, 2024
### Added
Adding custom tableview cell feature

## v0.6.0 
> May 01, 2024
### Added
Adding error management

## 0.5.0
> Apr 30, 2024
### Changed
Cleaned code + Added Marks to help navigate code + ViewModel and Delegate for MovieDetailViewController

## 0.4.0
> Apr 30, 2024
### Changed
- Fetching view for MovieDetail
- Separating logic from MovieSearchList into ViewModel

## v0.3.0
> Apr 30, 2024
### Added
- Added animation to hide/show search bar 
- NetworkManager search for all movies
- created Search model

## v0.2.0
 > Apr 30, 2024
### Added
Initial commit with ongoing project
containing: 
- Movie detail view 
- working on MoviesSearchList (WIP)

## v0.1.x
> Apr 30, 2024
### Added
initial commit to start repository 

---
---
See Git commit log or https://github.com/LucasCBarros/EnsembleMoviesOMDB/.
