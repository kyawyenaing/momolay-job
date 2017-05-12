class Job < ActiveRecord::Base

  belongs_to :city 
  belongs_to :category
  belongs_to :salary_range
  belongs_to :user
  belongs_to :company

  enum job_type: { FULLTIME: 0, PARTTIME: 1 , FREELANCE: 2, INTERNSHIP: 3}

  validates_presence_of :title, :company_id, :job_type, 
    :category_id, :salary_range_id, :city_id, :description, :requirement, 
    :how_to
    

# for user dashboard
  def self.my_jobs(user_id, page = 1)
    num_jobs = 5
    Job.where(['user_id = ?', user_id])
      .order(created_at: :DESC)
      .page(page).per(num_jobs)
  end
# end user dashboard

# for job by company
  def self.comp_jobs( company_id, page = 1 )
    num_jobs = 5
    Job.where(['company_id = ?', company_id])
      .order(created_at: :DESC)
      .page(page).per(num_jobs)
  end
# comp_jobs_count
  def self.comp_jobs_count( company_id )
    Job.where(['company_id = ?', company_id])
      .order(created_at: :DESC)
      .count
  end
# end comp_jobs_count

# for job display and filter
  def self.get_list( title, city_id, page = 1 )
    num_jobs =  5

    if title == nil && city_id == nil
    Job.order(created_at: :DESC)
        .page(page).per(num_jobs)
    else
      if title != "" && city_id != ""
          Job.where(['title LIKE ? && city_id = ?', title, city_id])
            .order(created_at: :DESC)
            .page(page).per(num_jobs)
      end
      if title != ""
        Job.where(['title LIKE ?', title])
          .order(created_at: :DESC)
          .page(page).per(num_jobs)
      else
        Job.where(['city_id = ?', city_id])
          .order(created_at: :DESC)
          .page(page).per(num_jobs)
      end
    end
  end
# end job display and filter

# for date time
  def decorated_created_at
    created_at.to_date.to_s(:long)
    # created_at.strftime "%d/%m/%Y %H:%M"
  end
# end datetime

  def self.get_count( title, city_id)

    if title == nil && city_id == nil
    Job.order(created_at: :DESC)
        .count
    else
      if title != "" && city_id != ""
          Job.where(['title LIKE ? and city_id = ?', title, city_id])
            .order(created_at: :DESC)
            .count
      end
      if title != ""
        Job.where(['title LIKE ?', title])
          .order(created_at: :DESC)
          .count
      else
        Job.where(['city_id = ?', city_id])
          .order(created_at: :DESC)
          .count
      end
    end
  end

  # for api
    # def self.get_api( )
    #   Job.order(created_at: :DESC)       
    # end
  # end api

  # for api
    # def self.get_comp_job_api( company_id )
    #   Job.where(['company_id = ?', company_id])
    #       .order(created_at: :DESC)       
    # end
  # end api

  # for api with pagination
    # def self.get_comp_job_api( company_id , page )
    #   num = 5
    #   Job.where(['company_id = ?', company_id])
    #       .order(created_at: :DESC)   
    #       .page(page).per(num)    
    # end
  # end api

end
