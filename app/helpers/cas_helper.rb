module CasHelper
  include BooleanHelper

    class LoginResponse
      attr_accessor :type, :tgt, :msg

      def initialize(params)
        attrs = %w(type tgt)
        attrs.each { |attr| self.instance_variable_set("@#{attr}", params[attr]) }
        message = params["message"]
        @msg = message["untranslated_path"]
      end
    end

    def cas_sign_in(user)
      loginResponse = login(user.email, user.encrypted_password)
      tgt = loginResponse.tgt
    end

    #def cas_sign_out(user)
    #
    #  logout(tgt) if tgt
    #  #cookies.delete('tgt')
    #end

    def cas_sign_out_tgt(tgt)
      logout(tgt) if tgt
    end

    def cas_enable?
      parse_boolean Account.default.settings[:cas_enable]
    end

    def cas_cookie_domain
      parse_boolean "#{Settings.cas.tgt_cookie_domain}"
    end

    private

        def login_url
          "#{@domain_root_account.settings[:cas_url]}#{@domain_root_account.settings[:cas_login_path]}"
        end

        def logout_url
          "#{@domain_root_account.settings[:cas_url]}#{@domain_root_account.settings[:cas_logout_path]}"
        end     

        def login(username, password)
          #puts login_url
          response_bytes =  RestClient::Request.execute(:method => :post, :url => login_url,
                                                        :payload => {:username => username, :password => password} )
          response_json =JSON.parse(response_bytes)
          #puts response_json
          LoginResponse.new(response_json)
        end

        def logout(tgt)
          response_bytes =  RestClient.delete(logout_url, {:cookies => {:tgt => "#{tgt}"}})
          json = JSON.parse(response_bytes)
          #puts json
          message = json["message"]
          message["untranslated_path"]
        end
end