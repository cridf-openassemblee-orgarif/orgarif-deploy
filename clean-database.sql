drop index if exists app_user_mail_idx;

drop index if exists app_user_username_idx;

drop index if exists instance_organisme_id_idx;

drop index if exists lien_deliberation_organisme_id_idx;

drop index if exists mail_log_user_id_idx;

drop index if exists representation_instance_id_idx;

drop index if exists representation_organisme_id_idx;

drop index if exists spring_session_expiry_time_idx;

drop index if exists spring_session_principal_name_idx;

drop index if exists suppleance_organisme_id_idx;

drop index if exists user_session_log_user_id_idx;

alter table public.command_log drop constraint command_log_deployment_log_id_fkey;

alter table public.command_log drop constraint command_log_user_id_fkey;

alter table public.command_log drop constraint command_log_user_session_id_fkey;

alter table public.instance drop constraint instance_organisme_id_fkey;

alter table public.lien_deliberation drop constraint lien_deliberation_deliberation_id_fkey;

alter table public.lien_deliberation drop constraint lien_deliberation_instance_id_fkey;

alter table public.lien_deliberation drop constraint lien_deliberation_organisme_id_fkey;

alter table public.magic_link_token drop constraint magic_link_token_user_id_fkey;

alter table public.mail_log drop constraint mail_log_deployment_log_id_fkey;

alter table public.organisme drop constraint organisme_nature_juridique_id_fkey;

alter table public.organisme drop constraint organisme_secteur_id_fkey;

alter table public.organisme drop constraint organisme_type_structure_id_fkey;

alter table public.representant drop constraint representant_elu_id_fkey;

alter table public.representation drop constraint representation_instance_id_fkey;

alter table public.representation drop constraint representation_organisme_id_fkey;

alter table public.representation drop constraint representation_representant_id_fkey;

alter table public.spring_session_attributes drop constraint spring_session_attributes_session_primary_id_fkey;

alter table public.suppleance drop constraint suppleance_organisme_id_fkey;

alter table public.suppleance drop constraint suppleance_representant_id_fkey;

alter table public.suppleance drop constraint suppleance_representation_id_fkey;

alter table public.user_file drop constraint user_file_user_id_fkey;

alter table public.user_session_log drop constraint user_session_log_user_id_fkey;

drop table if exists public.app_user;

drop table if exists public.command_log;

drop table if exists public.deliberation;

drop table if exists public.deployment_log;

drop table if exists public.elu;

drop table if exists public.instance;

drop table if exists public.lien_deliberation;

drop table if exists public.magic_link_token;

drop table if exists public.mail_log;

drop table if exists public.nature_juridique;

drop table if exists public.organisme;

drop table if exists public.representant;

drop table if exists public.representation;

drop table if exists public.secteur;

drop table if exists public.spring_session;

drop table if exists public.spring_session_attributes;

drop table if exists public.suppleance;

drop table if exists public.type_structure;

drop table if exists public.user_file;

drop table if exists public.user_session_log;

