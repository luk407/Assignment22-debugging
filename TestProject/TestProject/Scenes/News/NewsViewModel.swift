//
//  NewsViewModel.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import Foundation

protocol NewsViewModelDelegate: AnyObject { //added AnyObject
    func newsFetched(_ news: [News])
    func showError(_ error: Error)
}

protocol NewsViewModel {
    var delegate: NewsViewModelDelegate? { get set }
    func viewDidLoad()
}

final class DefaultNewsViewModel: NewsViewModel {
    
    // MARK: - Properties
    private let newsAPI = "https://newsapi.org/v2/everything?q=tesla&from=2023-10-24&sortBy=publishedAt&apiKey=ce67ca95a69542b484f81bebf9ad36d5" //switched date to 2023-10-24 (requires update every next day)
    
    private var newsList: [News]?

    weak var delegate: NewsViewModelDelegate?

    // MARK: - Public Methods
    func viewDidLoad() {
        fetchNews()
    }
    
    // MARK: - Private Methods
    private func fetchNews() {
        NetworkManager.shared.get(urlString: newsAPI) { [weak self] (result: Result<Article, Error>) in
            switch result {
            case .success(let article):
                self?.newsList = article.articles // I changed 'articles' to array of News, so it can't be appended to list anymore.
                self?.delegate?.newsFetched(article.articles) // just passing result array directly, instead of passing newsList, which would require a couple of '?' and '!', which would work, but would look ugly
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}

