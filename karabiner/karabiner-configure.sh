#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set remap.mouse_keys_mode_3 1
/bin/echo -n .
$cli set repeat.initial_wait 201
/bin/echo -n .
$cli set parameter.acceleration_of_scroll 0
/bin/echo -n .
$cli set parameter.mousekey_repeat_wait_of_scroll 5
/bin/echo -n .
$cli set parameter.maximum_speed_of_scroll 5
/bin/echo -n .
$cli set parameter.simultaneouskeypresses_delay 100
/bin/echo -n .
$cli set parameter.mousekey_high_speed_of_scroll 10
/bin/echo -n .
$cli set parameter.mousekey_initial_wait_of_scroll 5
/bin/echo -n .
$cli set remap.app_firefox_tmux 1
/bin/echo -n .
$cli set parameter.mousekey_repeat_wait_of_pointer 5
/bin/echo -n .
$cli set parameter.mousekey_initial_wait_of_pointer 5
/bin/echo -n .
$cli set repeat.wait 31
/bin/echo -n .
$cli set repeat.consumer_wait 10
/bin/echo -n .
$cli set parameter.blockuntilkeyup_timeout 0
/bin/echo -n .
$cli set remap.mouse_navigation 1
/bin/echo -n .
$cli set parameter.wait_before_and_after_a_modifier_key_event 30
/bin/echo -n .
/bin/echo
