/*
 * Copyright (C) 1997-2001 Id Software, Inc.
 * Copyright (C) 2011 Yamagi Burmeister
 * Copyright (c) ZeniMax Media Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * =======================================================================
 *
 * Functionpointers to every spawn function in the game.so.
 *
 * =======================================================================
 */

{"item_health", SP_item_health},
{"item_health_small", SP_item_health_small},
{"item_health_large", SP_item_health_large},
{"item_health_mega", SP_item_health_mega},

{"info_player_start", SP_info_player_start},
{"info_player_deathmatch", SP_info_player_deathmatch},
{"info_player_coop", SP_info_player_coop},
{"info_player_intermission", SP_info_player_intermission},
{"info_player_team1", SP_info_player_team1},
{"info_player_team2", SP_info_player_team2},

{"func_plat", SP_func_plat},
{"func_button", SP_func_button},
{"func_door", SP_func_door},
{"func_door_secret", SP_func_door_secret},
{"func_door_rotating", SP_func_door_rotating},
{"func_rotating", SP_func_rotating},
{"func_train", SP_func_train},
{"func_water", SP_func_water},
{"func_conveyor", SP_func_conveyor},
{"func_areaportal", SP_func_areaportal},
{"func_clock", SP_func_clock},
{"func_wall", SP_func_wall},
{"func_object", SP_func_object},
{"func_timer", SP_func_timer},
{"func_explosive", SP_func_explosive},
{"func_killbox", SP_func_killbox},

{"trigger_always", SP_trigger_always},
{"trigger_once", SP_trigger_once},
{"trigger_multiple", SP_trigger_multiple},
{"trigger_relay", SP_trigger_relay},
{"trigger_push", SP_trigger_push},
{"trigger_hurt", SP_trigger_hurt},
{"trigger_key", SP_trigger_key},
{"trigger_counter", SP_trigger_counter},
{"trigger_elevator", SP_trigger_elevator},
{"trigger_gravity", SP_trigger_gravity},
{"trigger_monsterjump", SP_trigger_monsterjump},

{"target_temp_entity", SP_target_temp_entity},
{"target_speaker", SP_target_speaker},
{"target_explosion", SP_target_explosion},
{"target_changelevel", SP_target_changelevel},
{"target_secret", SP_target_secret},
{"target_goal", SP_target_goal},
{"target_splash", SP_target_splash},
{"target_spawner", SP_target_spawner},
{"target_blaster", SP_target_blaster},
{"target_crosslevel_trigger", SP_target_crosslevel_trigger},
{"target_crosslevel_target", SP_target_crosslevel_target},
{"target_laser", SP_target_laser},
{"target_help", SP_target_help},
{"target_lightramp", SP_target_lightramp},
{"target_earthquake", SP_target_earthquake},
{"target_character", SP_target_character},
{"target_string", SP_target_string},

{"worldspawn", SP_worldspawn},
{"viewthing", SP_viewthing},

{"light", SP_light},
{"light_mine1", SP_light_mine1},
{"light_mine2", SP_light_mine2},
{"info_null", SP_info_null},
{"func_group", SP_info_null},
{"info_notnull", SP_info_notnull},
{"path_corner", SP_path_corner},
{"point_combat", SP_point_combat},

{"misc_explobox", SP_misc_explobox},
{"misc_banner", SP_misc_banner},
{"misc_ctf_banner", SP_misc_ctf_banner},
{"misc_ctf_small_banner", SP_misc_ctf_small_banner},
{"misc_satellite_dish", SP_misc_satellite_dish},
{"misc_gib_arm", SP_misc_gib_arm},
{"misc_gib_leg", SP_misc_gib_leg},
{"misc_gib_head", SP_misc_gib_head},
{"misc_viper", SP_misc_viper},
{"misc_viper_bomb", SP_misc_viper_bomb},
{"misc_bigviper", SP_misc_bigviper},
{"misc_strogg_ship", SP_misc_strogg_ship},
{"misc_teleporter", SP_misc_teleporter},
{"misc_teleporter_dest", SP_misc_teleporter_dest},
{"trigger_teleport", SP_trigger_teleport},
{"info_teleport_destination", SP_info_teleport_destination},
{"misc_blackhole", SP_misc_blackhole},
{"misc_eastertank", SP_misc_eastertank},
{"misc_easterchick", SP_misc_easterchick},
{"misc_easterchick2", SP_misc_easterchick2},

{NULL, NULL}
