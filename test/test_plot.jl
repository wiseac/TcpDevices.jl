using TcpInstruments
using Plots; gr()
scope = initialize(AgilentDSOX4034A,  "10.1.30.32")
data = get_data(scope, 1)
plot(data)
