BEGIN TRANSACTION;
CREATE TABLE elu
(
    id UUID PRIMARY KEY NOT NULL,
    civilite VARCHAR(3) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    groupe_politique VARCHAR(255) NOT NULL,
    groupe_politique_court VARCHAR(255) NOT NULL,
    image_url VARCHAR(255),
    actif BOOLEAN NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL
);

CREATE TABLE nature_juridique
(
    id UUID PRIMARY KEY NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL
);

CREATE TABLE departement
(
    id UUID PRIMARY KEY NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    code VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL
);

CREATE TABLE secteur
(
    id UUID PRIMARY KEY NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL
);

CREATE TABLE deliberation
(
    id UUID PRIMARY KEY NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    search_libelle VARCHAR(255) NOT NULL,
    deliberation_date DATE NOT NULL,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL
);

CREATE TABLE type_structure
(
    id UUID PRIMARY KEY NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL
);

CREATE TABLE spring_session
(
    primary_id CHAR(36) PRIMARY KEY,
    session_id CHAR(36) NOT NULL UNIQUE,
    creation_time BIGINT NOT NULL,
    last_access_time BIGINT NOT NULL,
    max_inactive_interval INTEGER NOT NULL,
    expiry_time BIGINT NOT NULL,
    principal_name VARCHAR(255)
);

CREATE TABLE app_user
(
    id UUID PRIMARY KEY,
    mail VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(60) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    language VARCHAR(2) NOT NULL,
    roles VARCHAR(255)[] NOT NULL,
    signup_date TIMESTAMPTZ NOT NULL,
    last_update TIMESTAMPTZ NOT NULL
);

CREATE TABLE deployment_log
(
    id UUID PRIMARY KEY,
    build_version VARCHAR(255) NOT NULL,
    system_zone_id VARCHAR(255) NOT NULL,
    startup_date TIMESTAMPTZ NOT NULL,
    shutdown_date TIMESTAMPTZ
);

CREATE TABLE representant
(
    id UUID PRIMARY KEY NOT NULL,
    elu_id UUID,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    search_prenom VARCHAR(255) NOT NULL,
    search_nom VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (elu_id) REFERENCES elu (id)
);

CREATE TABLE organisme
(
    id UUID PRIMARY KEY NOT NULL,
    nom VARCHAR(255) NOT NULL,
    departement_id UUID,
    nature_juridique_id UUID,
    secteur_id UUID,
    type_structure_id UUID,
    nombre_representants INTEGER NOT NULL,
    presence_suppleants BOOLEAN NOT NULL,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (secteur_id) REFERENCES secteur (id),
    FOREIGN KEY (nature_juridique_id) REFERENCES nature_juridique (id),
    FOREIGN KEY (type_structure_id) REFERENCES type_structure (id)
);

CREATE TABLE spring_session_attributes
(
    session_primary_id CHAR(36) NOT NULL,
    attribute_name VARCHAR(200) NOT NULL,
    attribute_bytes BYTEA NOT NULL,
    PRIMARY KEY (session_primary_id, attribute_name),
    FOREIGN KEY (session_primary_id) REFERENCES spring_session (primary_id) ON DELETE CASCADE
);

CREATE TABLE user_file
(
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    file_content BYTEA NOT NULL,
    content_type VARCHAR(255) NOT NULL,
    original_filename TEXT NOT NULL,
    upload_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE magic_link_token
(
    token VARCHAR(255) PRIMARY KEY,
    user_id UUID NOT NULL,
    -- TODO[tmpl][magic-link] create an index here
    validity BOOLEAN NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_update TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE user_mail_log
(
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    mail VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE user_session_log
(
    id UUID PRIMARY KEY,
    spring_session_id VARCHAR(255) NOT NULL,
    user_id UUID NOT NULL,
    deployment_log_id UUID NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    ip VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE command_log
(
    id UUID PRIMARY KEY,
    user_id UUID,
    affected_user_id UUID,
    deployment_log_id UUID NOT NULL,
    command_class VARCHAR(255) NOT NULL,
    json_command TEXT NOT NULL,
    ip VARCHAR(255) NOT NULL,
    user_session_id UUID,
    ids_log TEXT NOT NULL,
    json_result TEXT,
    exception_stack_trace TEXT,
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (deployment_log_id) REFERENCES deployment_log (id)
);

CREATE TABLE mail_log
(
    id UUID PRIMARY KEY,
    deployment_log_id UUID NOT NULL,
    user_id UUID NOT NULL,
    reference VARCHAR(255) NOT NULL,
    recipient_mail VARCHAR(255) NOT NULL,
    data TEXT NOT NULL,
    subject TEXT NOT NULL,
    content TEXT NOT NULL,
    date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (deployment_log_id) REFERENCES deployment_log (id)
);

CREATE TABLE instance
(
    id UUID PRIMARY KEY NOT NULL,
    nom VARCHAR(255) NOT NULL,
    organisme_id UUID NOT NULL,
    nombre_representants INTEGER NOT NULL,
    presence_suppleants BOOLEAN NOT NULL,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (organisme_id) REFERENCES organisme (id)
);

CREATE TABLE lien_deliberation
(
    id UUID PRIMARY KEY NOT NULL,
    organisme_id UUID NOT NULL,
    instance_id UUID,
    deliberation_id UUID NOT NULL,
    comment TEXT,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (deliberation_id) REFERENCES deliberation (id),
    FOREIGN KEY (organisme_id) REFERENCES organisme (id),
    FOREIGN KEY (instance_id) REFERENCES instance (id)
);

CREATE TABLE designation
(
    id UUID PRIMARY KEY NOT NULL,
    representant_id UUID NOT NULL,
    organisme_id UUID NOT NULL,
    instance_id UUID,
    type VARCHAR(255) NOT NULL,
    position INT NOT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(255) NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL,
    last_modification_date TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (representant_id) REFERENCES representant (id),
    FOREIGN KEY (organisme_id) REFERENCES organisme (id),
    FOREIGN KEY (instance_id) REFERENCES instance (id)
);

CREATE INDEX ON lien_deliberation (organisme_id);

CREATE INDEX ON instance (organisme_id);

CREATE INDEX ON organisme (departement_id);

CREATE INDEX ON organisme (nature_juridique_id);

CREATE INDEX ON organisme (secteur_id);

CREATE INDEX ON organisme (type_structure_id);

CREATE INDEX ON designation (representant_id);

CREATE INDEX ON designation (organisme_id);

CREATE INDEX ON designation (instance_id);

CREATE INDEX ON spring_session (expiry_time);

CREATE INDEX ON spring_session (principal_name);

CREATE INDEX ON user_mail_log (user_id);

CREATE INDEX ON app_user (mail);

CREATE INDEX ON user_session_log (user_id);

CREATE INDEX ON mail_log (user_id);
COMMIT;