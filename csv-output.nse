-- The Head Section
description = [[A script to output nmap data to CSV format.
The output contains the host, its IP address, the scanned port, the protocol, the port state, the service and its version]]

---
-- @usage
-- nmap --script csv-output --script-args=filename=myscan.csv <target>
-- @args
-- filename: name of the csv file (default: scan.csv)

author     = "Anne-Gwenn Kettunen"
license    = "MIT"
categories = {"external","safe"}

local nmap = require "nmap"

-- The Rule Section

function prerule ()
  file:write("hostname,ip,port,protocol,state,service,version\n") -- This will be the header of the CSV file
end

portrule = function() return true end
postrule = function() return true end

if (nmap.registry.args.filename~=nil) then
  filename = nmap.registry.args.filename
else
  filename = "scan.csv"
end

file = io.open(filename, "a")

-- This is where everything happens
function portaction (host, port)
  local version = ""

  if (port.version.product ~= nil) then
    version = port.version.product 
  end

  if (port.version.version ~= nil) then
    version = version .. port.version.version
  end

  data = { host.name .. "," .. host.ip .. "," .. port.number .. "," .. port.protocol
.. "," .. port.state .. "," .. port.service .. "," .. version }

  -- write_as_csv(file,data)
  csv_data = to_CSV(data)
  file:write(csv_data)

end


function postaction ()
  io.close(file)
end


local actiontable = {
  portrule = portaction,
  postrule = postaction
}

action = function(...) return actiontable[SCRIPT_TYPE](...) end

-- CSV Utils

-- Used to escape "'s by toCSV
function escapeCSV (s)
  if string.find(s, '[,"]') then
    s = string.gsub(s, '"', '""')
  end
  return s
end

function to_CSV (tt)
  local s = ""
-- ChM 23.02.2014: changed pairs to ipairs 
-- assumption is that fromCSV and toCSV maintain data as ordered array
  for _,p in ipairs(tt) do  
    s = s .. "," .. escapeCSV(p) .. '\n'
  end
  return string.sub(s, 2)      -- remove first comma
end
