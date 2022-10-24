# frozen_string_literal: true

require 'sqlite3'

class DB
  attr_accessor :db

  def initialize(db_path)
    create_db(db_path) unless File.exist?(db_path)

    @db = SQLite3::Database.new(db_path, readwrite: true)
  end

  def create_db(db_path)
    db = SQLite3::Database.new db_path
    db.execute('CREATE TABLE jobs (id INTEGER PRIMARY_KEY, published_at text, expires_at text)')
    db
  end

  def finalize
    @db.close
  end

  def add_job(job)
    @db.execute('INSERT INTO jobs (id, published_at, expires_at) VALUES (?, ?, ?)',
                [job.id, job.published_at, job.expires_at])
  end

  def job_exist?(job)
    @db.execute('SELECT published_at, expires_at FROM jobs WHERE id = ?', [job.id]).length.positive?
  end

  def job_metadata(job)
    @db.execute('SELECT published_at, expires_at FROM jobs WHERE id = ?', [job.id])
  end
end
