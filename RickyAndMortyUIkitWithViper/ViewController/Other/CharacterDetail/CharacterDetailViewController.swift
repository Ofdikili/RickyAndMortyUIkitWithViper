import UIKit

class CharacterDetailViewController : UIViewController{
    
    var detailUIView : CharacterDetailUIView
    
    private let detailVm : CharacterDetailUIViewModel
    
    init(detailVm : CharacterDetailUIViewModel) {
        self.detailVm = detailVm
        self.detailUIView = CharacterDetailUIView(
            frame: .zero, viewModel: detailVm
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailUIView)
        addConstraints()
        detailUIView.collectionView?.delegate = self
        detailUIView.collectionView?.dataSource = self
        navigationItem.title = detailVm.character.name


    }
   
    func addConstraints(){
        NSLayoutConstraint.activate([
            detailUIView.topAnchor.constraint(equalTo: view.topAnchor),
            detailUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailUIView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailUIView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

extension CharacterDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch detailVm.sections[section]{
        case .photo:
            return 1
        case .info(let viewModels):
            return viewModels.count
        case .episode(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return detailVm.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch detailVm.sections[indexPath.section]{
        case .photo(let vm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifider, for: indexPath) as? PhotoCollectionViewCell
            else {fatalError("error")}
            cell.configure(vm)
            return cell
        case .info(let vm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.identifider, for: indexPath) as? InformationCollectionViewCell
            else {fatalError("error")}
            cell.configure(viewModel: vm[indexPath.row])
            return cell
        case .episode(let vm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCollectionViewCell.identifider, for: indexPath) as? EpisodeCollectionViewCell else {fatalError()}
            cell.configure(vm[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch detailVm.sections[indexPath.section]{
        case .photo , .info :
            break
        case .episode:
            let episodes = self.detailVm.episodes
            let selection = episodes[indexPath.row]
            let vc = EpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
