module RequestSpecHelper 
  #parse Json response to ruby hash 
  def json 
  	JSON.parse(response.body)
  end
end