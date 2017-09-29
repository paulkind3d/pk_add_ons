-- Written by Paul Kind 2017

pk_world = pk_world or {}
pk_math = pk_math or {}

function pk_world.get_world()
    return stingray.Application.flow_callback_context_world()
end

function pk_world.get_physics_world()
    return stingray.World.physics_world(pk_world.get_world())
end

function pk_world.get_delta_time()
    return stingray.World.delta_time(pk_world.get_world())
end

require 'pk_add_ons/scripts/laser_pointer'
require 'pk_add_ons/scripts/get_distance'
require 'pk_add_ons/scripts/super_debugger'
require 'pk_add_ons/scripts/super_sum'
require 'pk_add_ons/scripts/super_concatenator'
require 'pk_add_ons/scripts/replace_and_remember_material'
require 'pk_add_ons/scripts/replace_material'
require 'pk_add_ons/scripts/color_to_percent'
require 'pk_add_ons/scripts/look_at_unit'
require 'pk_add_ons/scripts/vector_lerp_over_time'
require 'pk_add_ons/scripts/enable_cursor'
require 'pk_add_ons/scripts/single_sequence'
require 'pk_add_ons/scripts/light_flicker'
require 'pk_add_ons/scripts/system_time'
require 'pk_add_ons/scripts/nth_update'
require 'pk_add_ons/scripts/gaze_teleport'
require 'pk_add_ons/scripts/do_once_with_reset'
require 'pk_add_ons/scripts/simple_timer'
require 'pk_add_ons/scripts/multi_bool_tester'
require 'pk_add_ons/scripts/file_writer'
require 'pk_add_ons/scripts/quit'
