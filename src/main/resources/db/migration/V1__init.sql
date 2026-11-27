CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    login_id VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(30) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    github_username VARCHAR(50) NULL,
    github_token VARCHAR(512) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE goals (
    goal_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(100) NOT NULL,
    category VARCHAR(20) NOT NULL,
    github_repo VARCHAR(150) NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    extended_count INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS',
    ai_graduation_note TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_goals_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE pets (
    pet_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    goal_id BIGINT NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    personality_prompt TEXT NOT NULL,
    appearance_json JSON NOT NULL,
    equipped_items_json JSON NOT NULL,
    evolution_stage INT NOT NULL DEFAULT 1,
    exp INT NOT NULL DEFAULT 0,
    stat_int INT NOT NULL DEFAULT 0,
    stat_str INT NOT NULL DEFAULT 0,
    stat_dev INT NOT NULL DEFAULT 0,
    condition_score INT NOT NULL DEFAULT 100,
    status VARCHAR(20) NOT NULL DEFAULT 'NORMAL',
    consecutive_rest_count INT NOT NULL DEFAULT 0,
    last_active_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_widget_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pets_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_pets_goal FOREIGN KEY (goal_id) REFERENCES goals(goal_id) ON DELETE CASCADE,
    INDEX idx_pets_user_widget (user_id, is_widget_active),
    INDEX idx_pets_penalty_scan (status, last_active_at)
);

CREATE TABLE tasks (
    task_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    goal_id BIGINT NOT NULL,
    title VARCHAR(150) NOT NULL,
    tag VARCHAR(20) NOT NULL,
    due_date DATE NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    completed_at DATETIME NULL,
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_tasks_goal FOREIGN KEY (goal_id) REFERENCES goals(goal_id) ON DELETE CASCADE,
    INDEX idx_tasks_goal_date (goal_id, due_date)
);

CREATE TABLE activity_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    pet_id BIGINT NOT NULL,
    source_type VARCHAR(20) NOT NULL,
    external_ref_id VARCHAR(100) NULL,
    description VARCHAR(255) NOT NULL,
    gained_exp INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_logs_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_logs_pet FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    CONSTRAINT uq_pet_external_ref UNIQUE (pet_id, external_ref_id),
    INDEX idx_logs_pet_created (pet_id, created_at DESC)
);