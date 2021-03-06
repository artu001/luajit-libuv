require 'uv/util/strict'
local loop = require 'uv.loop'
local process = require 'uv.process'
local timer = require 'uv.timer'
local expect = require 'uv/util/expect'

do
  local signal = process.spawn { './luajit', '-v' }
  expect.equal(signal, 0)

  local signal = process.spawn { '/bin/echo', 'Hello', 'world' }
  expect.equal(signal, 0)
end

loop.run(function()
  local count = 0
  process.on('hup', function()
    count = count + 1
  end)
  process.kill(process.pid(), 'hup')
  process.kill(process.pid(), 'hup')
  process.kill(process.pid(), 'hup')
  timer.sleep(1)
  expect.equal(count, 3)
  loop.stop()
end)

do
  assert(process.path():find('luajit'))
end
