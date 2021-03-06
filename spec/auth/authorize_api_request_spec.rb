require 'rails_helper'

RSpec.describe AuthorizeApiRequest do 
  let(:user) { create(:user)}
  # Mock 'Authorization' header
  let(:header) { {'Authorization' => token_generator(user.id)}}
  # Invalid request subject
  subject(:invalid_request_obj) { described_class.new({})}
  # Valid request subject
  subject(:request_obj) { described_class.new(header)}

  describe 'AuthorizeApiRequest#call' do 
    # Entry point into service class 
    describe '#call' do 
      context 'when valid request' do 
      	it 'returns user object' do 
      		result = request_obj.call 
      		expect(result[:user]).to eq(user)
      	end
      end

      context 'when invalid token' do 
      	subject(:invalid_request_obj) do 
      	  # custom helper method 'token_generator'
      	  described_class.new('Authorization' => token_generator(5))
      	end

      	it 'raises an Invalid Token error' do 
      	  expect { invalid_request_obj.call}
      	    .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
      	end
      end

      context 'when token is expired' do 
      	let(:header) { { 'Authorization'=> expired_token_generator(user.id)} }
      	subject(:request_obj) {described_class.new(header)}

      	it 'raises ExceptionHandler::ExpiredSignature error' do 
      	  expect { request_obj.call }
      	    .to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/)
      	end
      end

      context 'fake token' do 
      	let(:header) { { 'Authorization'=> 'foobar'} }
      	subject(:invalid_request_obj) {described_class.new(header)}

      	it 'handles JWT::DecodeError' do 
      	  expect { invalid_request_obj.call } 
      	    .to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
      	end
      end
    end
  end
end