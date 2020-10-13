class Api::V1::ApiController < ActionController::API
	def products
		@products = ProductDetail.where(status: true)
		render json: @products
	end

	def article
		@article = Article.all
		render json: @article
	end

	def url_paser
		require 'net/http'
		require 'json'

		url = 'https://newsapi.org/v2/top-headlines?sources=google-news&apiKey=0a708bae59cd4f92b26a6bc4c114f1f0'
		uri = URI(url)
		response = Net::HTTP.get(uri)
		data =  JSON.parse(response)

		data['articles'].each do |art|
			article = Article.create(name: art['source']['name'], author: art['author'],title: art['title'], description: art['description'], url: art['url'], utlToImage: art['utlToImage'], published_at: art['published_at'], content: art['content'])
		end
		render json: data
	end
end
