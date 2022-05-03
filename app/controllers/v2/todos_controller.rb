class V2::TodosController < ApplicationController
  def index
  	json_response({message: "Hello, I am v2 :p"})
  end
end
