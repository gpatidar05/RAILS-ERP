class ChequeRegister < ActiveRecord::Base

  #Scope For the Active Record
  scope :with_active, -> { where('is_active = ?', true) }
  
  #Creator,Updater to your ActiveRecord objects
  track_who_does_it

  def self.search_box(search_text,current_user_id)
    search = where("cheque_registers.sales_user_id = ?",current_user_id)
    puts search
    if !/\A\d+\z/.match(search_text)
      code = search_text.gsub(/\D/,'')
      if code.present?
        search = search.where(id: code.to_i)
      else
        search = search.where("payee LIKE :search
          OR notes LIKE :search OR status LIKE :search", search: "%#{search_text}%")
      end
    else
      search = search.where("id :search OR debit :search
                OR credit :search ", search: "%#{search_text}%")
    end
    return search
  end



  def self.search(params,current_user_id)
    search = where("cheque_registers.sales_user_id = ?",current_user_id)
    search = search.where("cheque_registers.id = ?",params[:code].gsub(/\D/,'')) if params[:code].present?
    search = search.where('cheque_registers.payee = ?',params[:payee]) if params[:payee].present?
    search = search.where('cheque_registers.status = ?',params[:status]) if params[:status].present?
    search = search.where('cheque_registers.debit = ?',params[:debit]) if params[:debit].present?
    search = search.where('cheque_registers.credit = ?',params[:credit]) if params[:credit].present?
    search = search.where('DATE(cheque_registers.cheque_date) = ?', params[:cheque_date].to_date) if params[:cheque_date].present?
    search = search.where('DATE(cheque_registers.created_at) = ?', params[:created_at].to_date) if params[:created_at].present?
    search = search.where('cheque_registers.created_by_id = ?',params[:created_by_id]) if params[:created_by_id].present?
    return search
  end

  def get_json_cheque_register
    as_json(only: [:id, :payee, :cheque_date, :debit, :credit, :notes, :status])
    .merge({
      code:"ACC#{self.id.to_s.rjust(4, '0')}",
      created_at:self.created_at.strftime('%d %B, %Y'),
      created_by:self.creator.try(:full_name),
      updated_at:self.updated_at.strftime('%d %B, %Y'),
      updated_by:self.updater.try(:full_name),
    })
  end 

  def self.get_json_cheque_registers
    cheque_registers_list =[]
    all.each do |cheque_register|
      cheque_registers_list << cheque_register.get_json_cheque_register
    end
    return cheque_registers_list
  end

end
