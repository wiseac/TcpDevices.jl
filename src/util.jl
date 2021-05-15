using Sockets
using Base.Threads: @spawn
using Dates

function elapsed_time(start_time)
            seconds = floor(time() - start_time)
            return Time(0) + Second(seconds)
end

function elapsed_time(func, start_time)
            seconds = floor(time() - start_time)
            return Time(0) + Second(func(seconds))
end

"""
    scan_network(; ip_network="10.1.30.", ip_range=1:255)
Will scan your network and report all found devices.

By default it only searches for devices connected on port: 5025

If you would like to search for devices on a different port set the
v flag to true.
"""
function scan_network(; ip_network="10.1.30.", ip_range=1:255)
    ip_network = ensure_ending_dot(ip_network)

    @info "Scanning $ip_network$(ip_range[1])-$(ip_range[end])"
    # Scan for SCPI devices
    ips1 = asyncmap(
        x->_get_info_from_ip(x),
        [ip_network*"$ip" for ip in ip_range]
    )
    # Scan for Prologix device
    ips2 = asyncmap(
        x->_get_info_from_ip(x; port=1234),
        [ip_network*"$ip" for ip in ip_range]
    )
    println(typeof(ips2))
    ips_tot = [ips1 ips2]
    println(typeof(ips_tot))
    return [s for s in ips if !isempty(s)]
end
ensure_ending_dot(ip_network) = ip_network[end] != '.' ? ip_network*'.' : ip_network

function _get_info_from_ip(ip_str; port = 5025)
    temp_ip = ip_str * ":$port"
    proc = @spawn temp_ip => _get_instr_info_and_close(temp_ip)
    sleep(2)
    if proc.state == :runnable
        schedule(proc, ErrorException("Timed out"), error=true)
        return ""
    elseif proc.state == :done
        return fetch(proc)
    elseif proc.state == :failed
        v && return ip_str * ":????"
        return ""
    else
        error("Undefined $(proc.state)")
    end
end

function _get_instr_info_and_close(ip)
    instr = initialize(Instrument, ip)
    info_str = info(instr)
    close(instr)
    return info_str
end

udef(func) =  error("$(func) not implemented")

macro codeLocation()
           return quote
               st = stacktrace(backtrace())
               myf = ""
               for frm in st
                   funcname = frm.func
                   if frm.func != :backtrace && frm.func!= Symbol("macro expansion")
                       myf = frm.func
                       break
                   end
               end
               println("Running function ", $("$(__module__)"),".$(myf) at ",$("$(__source__.file)"),":",$("$(__source__.line)"))

               myf
           end
       end

function alias_print(msg)
    printstyled("[ Aliasing: ", color = :blue, bold = true)
    println(msg)
end

"""
	split_str_into_host_and_port(str)
Splits a string like "192.168.1.1:5056" into ("192.168.1.1", 5056)
"""
function split_str_into_host_and_port(str::AbstractString)::Tuple{String, Int}
	spl_str = split(str, ":")
	@assert !isempty(spl_str) "IP address string is empty!"
	host = spl_str[1]
	if length(spl_str) == 1
		port = 0
	else
		port = parse(Int, spl_str[2])
	end
	return (host, port)
end
