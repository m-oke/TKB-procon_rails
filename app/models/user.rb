# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_lessons, :foreign_key => :user_id
  has_many :lessons, :through => :user_lessons

  has_many :answers, :foreign_key => :student_id
  has_many :questions, :through => :answers

  ROLES = %i[root admin teacher student]

  def roles=(roles)
    roles = [*roles].map { |r| r.to_sym }
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
    ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_role?(role)
    roles.include?(role)
  end

  # ユーザが該当するrolesに所属するかどうか
  # @param [Array] role roleを記述した配列
  # @return [Boolean] 結果
  def has_roles?(role)
    role.each do |r|
      if !roles.include?(r)
        return false
      end
    end
    return true
  end
end
