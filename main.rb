require_relative 'lib/mastermind'

# cpu = MasterMind::ComputerPlayer.new
# p cpu.choose_colors

# hum = MasterMind::HumanPlayer.new
# hum.get_input('secret')

hum = MasterMind::HumanPlayer.new
cpu = MasterMind::ComputerPlayer.new

hum_vs_hum = MasterMind::Game.new(hum, hum)
# hum_vs_hum.play

hum_vs_cpu = MasterMind::Game.new(hum, cpu)
hum_vs_cpu.play