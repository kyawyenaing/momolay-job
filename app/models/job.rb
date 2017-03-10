class Job < ActiveRecord::Base

  belongs_to :city 
  belongs_to :category
  belongs_to :salary_range
  belongs_to :user

  enum job_type: { FULLTIME: 0, PARTTIME: 1 , FREELANCE: 2, INTERNSHIP: 3}

  validates_presence_of :title, :company_name, :job_type, 
    :category_id, :salary_range_id, :city_id, :description, :requirement, 
    :how_to

  def self.my_jobs(user_id, page = 1)
    num_jobs = 5 
    Job.where(['user_id = ?', user_id])
      .order(created_at: :DESC)
      .page(page).per(num_jobs)
  end

  def self.get_api( title, city_id)
    Job.order(created_at: :DESC)        
  end

  def self.get_list(title, city_id, page = 1)
    num_jobs = 5

    if title == nil && city_id == nil
    Job.order(created_at: :DESC)
        .page(page).per(num_jobs)
    else
      if title != "" && city_id != ""
          Job.where(['title LIKE ? and city_id = ?', title, city_id])
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


  def decorated_created_at
    created_at.to_date.to_s(:long)
  end

  def get_job_type
    if job_type == Job.job_types[:FULLTIME]
      "Full-time"
    else
      "Part-time"
    end
  end

end
