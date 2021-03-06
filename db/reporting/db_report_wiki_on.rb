# Copyright 2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rubygems'
require 'yaml'
require_relative 'db_reporter'

class WikiOnDbReporter < DbReporter

  def name()
    return "Wiki-Enabled Repositories"
  end

  def report_class()
    return 'repo-report'
  end

  def describe()
    return "This report shows repositories that have their wikis turned on. "
  end

  def db_columns()
    return [ 'Create Date', ['repository', 'org/repo'], ['Wiki', 'url'] ]
  end

  def db_report(context, repo, sync_db)
    wikiOn=sync_db["SELECT r.created_at, r.name FROM repository r WHERE has_wiki='1' AND r.org=? AND r.name=?", repo.owner.login, repo.name]
    text = ''
    wikiOn.each do |row|
      text << "  <reporting class='repo-report' repo='#{repo.full_name}' type='WikiOnDbReporter'><field>#{row[:created_at]}</field><field>#{repo.full_name}</field><field>#{context.github_url}/#{repo.full_name}/wiki</field></reporting>\n"
    end
    return text
  end

end
