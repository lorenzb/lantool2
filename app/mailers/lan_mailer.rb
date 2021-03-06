#!/bin/env ruby
# encoding: UTF-8

class LanMailer < ActionMailer::Base
  # ActionMailer doesn't seem to have before_filters...
  # before_filter :set_settings_from_db
  #LanMailer.smtp_settings = Settings.mailinglist_smtp_settings
  #ActionMailer::Base.smtp_settings = Settings.mailinglist_smtp_settings

  def registration_confirmation(attendance)
    @attendance = attendance
    @user       = attendance.user
    # todo: use enqueue_general_mail_to_user here
    mail(:to => "#{@user.name} <#{@user.email}>",
         :from => Settings.mailinglist_sender_email,
         :subject => "[LAN] Anmeldebestätigung").deliver
  end

  def enqueue_general_mail_to_user(mailinglist_user, subject, message, raw = false)
    @user    = mailinglist_user
    @message = message

    m = MailQueue.new
    m.from = Settings.mailinglist_sender_email
    m.to   = "#{@user.name} <#{@user.email}>"
    m.subject = subject

    if raw
      m.content = @message
    else
      m.content = render 'lan_mailer/mailinglist_mail'
    end

    m.save
  end
  
  def general_mail(m)
    mail(:to => m.to,
         :from => m.from,
         :subject => m.subject,
        ) do |format|
      format.text {render :text => m.clean_content}
      format.html {render :text => m.content}
    end
  end

  def task_done(message)
    @message = message
    mail(:to   => Settings.mailinglist_sender_email,
         :from => Settings.mailinglist_sender_email,
         :subject => '[rake] task done')
  end

  def start_processing
    system "RAILS_ENV=#{Rails.env} rake send_mails --trace 2>&1 >> #{Rails.root}/log/rake.log &"
  end

private

  def valid_from_email
    raise 'please set Settings.mailinglist_sender_email' if Settings.mailinglist_sender_email == 'EMAIL ADDRESS'
  end

  #def set_settings_from_db
  #  smtp_settings ||= Settings.mailinglist_smtp_settings
  #end
end
