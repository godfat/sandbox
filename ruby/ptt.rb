#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'

class Ptt
  attr_reader :user, :passwd, :out, :buf, :sock
  def initialize opt={}
    @user, @passwd = opt[:user], opt[:passwd]
    @out, @buf = opt[:out] || $stdout, ''
    @sock = TCPSocket.new('ptt.cc', 23)
  end

  def start
    print(wait('或以 new 註冊:'))
    write(user)
    write(passwd)
    print(wait('請按任意鍵繼續'))
    write("\r")
    print(read(1024))
    flush
    self
  end

  def wait str
    encoded = str.encode('big5-uao').force_encoding('binary')
    regexp = Regexp.new(encoded)
    until pos = buf =~ regexp
      break if IO.select([sock], nil, nil, 1).nil?
      buf << sock.readpartial(256)
    end
    if pos
      flush(pos + encoded.bytesize)
    else
      flush
    end
  end

  def flush size=buf.size
    result = buf[0...size]
    buf.slice!(0, size)
    result
  end

  def read size
    if size < buf.size
      flush(size)
    else
      prefix = flush
      remain = size - prefix.size
      while buf.size < size
        buf << sock.readpartial(remain)
      end
      prefix + flush(size)
    end
  end

  def write str
    sock.print("#{str}\r")
    self
  end

  def close
    sock.close
    puts
    self
  end

  def print str
    out.print str.#force_encoding('binary').
                  #tr("\b", '').
                  gsub(/\x00.*/, '').
                  gsub(/\e\[(;?\d)*[A-Za-z]/, '').
                  force_encoding('big5-uao').
                  encode('utf-8')
    self
  end
end

if ARGV.size == 2
  Ptt.new(user: ARGV.first, passwd: ARGV.last).start.close
else
  puts('Usage: ruby ptt.rb USER PASSWD')
  exit(1)
end
