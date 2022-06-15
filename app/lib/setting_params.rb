# frozen_string_literal: true

# set default setting params
class SetDefaultSettingParams
  def self.call(params)
    params['show_all'] = params['show_all'] ? 1 : 0
    params['accept_mail'] = params['accept_mail'] ? 1 : 0

    params
  end
end
