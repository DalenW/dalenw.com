# frozen_string_literal: true

git_commit = `git rev-parse HEAD`.strip!

GIT_COMMIT = git_commit

git_time = if Rails.env.production?
             Time.at `git show -s --format=%ct release`.strip!.to_i
           else
             Time.at `git show -s --format=%ct main`.strip!.to_i
           end
GIT_TIME = git_time.in_time_zone("America/Denver") # mountain time
