# 🗄️ SUPABASE DATABASE SCHEMA - BÁO CÔNG THƯƠNG

**Project**: DocNhanh - Hệ thống quản lý tòa soạn AI  
**Database**: PostgreSQL (Supabase)  
**Created**: October 23, 2025  
**Version**: 1.0  

---

## 📋 **MỤC LỤC**

1. [Overview](#overview)
2. [Database Schema](#database-schema)
3. [Tables Detail](#tables-detail)
4. [Relationships](#relationships)
5. [Indexes](#indexes)
6. [Row Level Security (RLS)](#row-level-security-rls)
7. [Sample Data](#sample-data)
8. [Migration Scripts](#migration-scripts)
9. [API Endpoints Mapping](#api-endpoints-mapping)
10. [Testing Checklist](#testing-checklist)

---

## 📊 **OVERVIEW**

### **Modules**:
```
1. Giao việc nội bộ (Tasks, Departments, Staff)
2. Quản lý nội dung AI (Articles, Scans, Schedules)
3. Quản trị hệ thống (Users, Permissions, Audit Logs)
4. AI Chat hỗ trợ nội bộ (Chat Messages, Usage Tracking)
5. Theme System (Config)
```

### **Database Stats**:
- **Tables**: 17 core tables
- **Sample Users**: 80 accounts (1 Admin + 79 Staff)
- **Sample Tasks**: ~100 tasks
- **Departments**: 13 phòng ban
- **Categories**: 8 loại công việc

---

## 🏗️ **DATABASE SCHEMA**

### **Schema Diagram**:

```
┌─────────────────────────────────────────────────────────────┐
│                    AUTHENTICATION & USERS                   │
├─────────────────────────────────────────────────────────────┤
│ users (auth)                                                │
│ ├── id (uuid, PK)                                          │
│ ├── username (unique)                                      │
│ ├── email                                                  │
│ ├── full_name                                              │
│ ├── role (Admin/Writer/View)                              │
│ └── ... (profile fields)                                  │
└─────────────────────────────────────────────────────────────┘
         │
         ├─── 1:1 ───┐
         │           │
         ▼           ▼
┌────────────────┐  ┌────────────────────────────────────────┐
│ staff          │  │ permissions                            │
│ ├── id         │  │ ├── id                                 │
│ ├── user_id ◄──┼──┤ ├── user_id                            │
│ ├── dept_id    │  │ ├── resource                           │
│ ├── position   │  │ └── actions[]                          │
│ └── role       │  └────────────────────────────────────────┘
└────────────────┘
         │
         │ M:1
         ▼
┌────────────────────────────────────────────────────────────┐
│ departments                                                │
│ ├── id (PK)                                               │
│ ├── name                                                  │
│ ├── leader_id ◄─── staff.id                              │
│ └── member_count                                          │
└────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    TASKS & ASSIGNMENTS                      │
├─────────────────────────────────────────────────────────────┤
│ tasks                                                       │
│ ├── id (uuid, PK)                                          │
│ ├── title                                                  │
│ ├── description                                            │
│ ├── status (pending/in_progress/completed/cancelled)      │
│ ├── priority (low/medium/high/urgent)                     │
│ ├── categories[] (array of category IDs)                  │
│ ├── created_by ◄─── users.id                              │
│ ├── department_id ◄─── departments.id                     │
│ ├── due_date                                               │
│ └── ... (timestamps)                                       │
└─────────────────────────────────────────────────────────────┘
         │
         ├─── 1:M ───┐
         │           │
         ▼           ▼
┌────────────────┐  ┌────────────────────────────────────────┐
│ task_assignments│ │ task_comments                          │
│ ├── id         │  │ ├── id                                 │
│ ├── task_id    │  │ ├── task_id                            │
│ ├── user_id    │  │ ├── user_id                            │
│ ├── role       │  │ ├── content                            │
│ └── assigned_at│  │ └── created_at                         │
└────────────────┘  └────────────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────────────────────────┐
│ task_attachments                                           │
│ ├── id                                                     │
│ ├── task_id                                                │
│ ├── file_name                                              │
│ ├── file_url (Supabase Storage)                           │
│ └── uploaded_by                                            │
└────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ task_categories (reference data)                           │
│ ├── id (PK)                                                │
│ ├── label                                                  │
│ ├── color                                                  │
│ ├── icon                                                   │
│ └── description                                            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    ARTICLES & CONTENT                       │
├─────────────────────────────────────────────────────────────┤
│ articles                                                    │
│ ├── id (uuid, PK)                                          │
│ ├── title                                                  │
│ ├── content (text/html)                                    │
│ ├── status (draft/review/published)                       │
│ ├── author_id ◄─── users.id                               │
│ ├── category                                               │
│ ├── keywords[]                                             │
│ ├── seo_score                                              │
│ ├── published_at                                           │
│ └── ... (metadata)                                         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ scans (quét tin tức)                                       │
│ ├── id (uuid, PK)                                          │
│ ├── url                                                    │
│ ├── title                                                  │
│ ├── content                                                │
│ ├── source                                                 │
│ ├── scan_type (auto/manual)                               │
│ ├── status (pending/completed/failed)                     │
│ └── scanned_at                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ schedules (lịch quét)                                      │
│ ├── id (uuid, PK)                                          │
│ ├── name                                                   │
│ ├── url                                                    │
│ ├── frequency (daily/weekly/monthly)                      │
│ ├── cron_expression                                        │
│ ├── enabled                                                │
│ └── last_run_at                                            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    AI CHAT & USAGE                          │
├─────────────────────────────────────────────────────────────┤
│ ai_chat_messages                                           │
│ ├── id (uuid, PK)                                          │
│ ├── user_id ◄─── users.id                                 │
│ ├── message                                                │
│ ├── response                                               │
│ ├── model (gpt-4o-mini, etc.)                             │
│ ├── tokens_used                                            │
│ └── created_at                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ ai_usage_logs                                              │
│ ├── id (uuid, PK)                                          │
│ ├── user_id ◄─── users.id                                 │
│ ├── action (chat/generate/scan/summarize)                 │
│ ├── model                                                  │
│ ├── tokens_input                                           │
│ ├── tokens_output                                          │
│ ├── cost_usd                                               │
│ ├── metadata (jsonb)                                       │
│ └── created_at                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    ADMIN & AUDIT                            │
├─────────────────────────────────────────────────────────────┤
│ audit_logs                                                 │
│ ├── id (uuid, PK)                                          │
│ ├── user_id ◄─── users.id                                 │
│ ├── action                                                 │
│ ├── resource_type                                          │
│ ├── resource_id                                            │
│ ├── changes (jsonb)                                        │
│ ├── ip_address                                             │
│ ├── user_agent                                             │
│ └── created_at                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ system_config                                              │
│ ├── id (uuid, PK)                                          │
│ ├── key (unique)                                           │
│ ├── value (jsonb)                                          │
│ ├── category                                               │
│ ├── description                                            │
│ └── updated_at                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 **TABLES DETAIL**

### **1. users** (Authentication & Profile)

```sql
CREATE TABLE users (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Authentication
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  
  -- Profile
  full_name VARCHAR(100) NOT NULL,
  avatar_url TEXT,
  phone VARCHAR(20),
  address TEXT,
  bio TEXT,
  
  -- Role & Status
  role VARCHAR(20) NOT NULL DEFAULT 'Writer' CHECK (role IN ('Admin', 'Writer', 'View')),
  disabled BOOLEAN DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login_at TIMESTAMP WITH TIME ZONE,
  
  -- Indexes
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_disabled ON users(disabled) WHERE disabled = false;
```

**Fields**:
- `id`: UUID primary key
- `username`: Unique identifier cho login (e.g., "admin", "vananhthai")
- `email`: Email address (unique)
- `password_hash`: Bcrypt hashed password
- `full_name`: Họ tên đầy đủ (e.g., "Nguyễn Văn Minh")
- `role`: 'Admin' | 'Writer' | 'View'
- `disabled`: Account có bị vô hiệu hóa không?

---

### **2. staff** (Nhân viên - extends users)

```sql
CREATE TABLE staff (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Link to User
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Staff Info
  staff_code VARCHAR(20) UNIQUE, -- Mã nhân viên (optional)
  position VARCHAR(100) NOT NULL, -- Chức vụ: Tổng Biên tập, Phóng viên, etc.
  
  -- Department
  department_id VARCHAR(50) REFERENCES departments(id) ON DELETE SET NULL,
  
  -- Role in Organization
  role VARCHAR(50) NOT NULL DEFAULT 'staff' CHECK (
    role IN (
      'editor_in_chief',    -- Tổng Biên tập
      'department_head',    -- Lãnh đạo phòng
      'deputy_head',        -- Phó phòng
      'secretary',          -- Thư ký
      'reporter',           -- Phóng viên
      'editor',             -- Biên tập viên
      'staff'               -- Nhân viên
    )
  ),
  
  -- Work Stats
  active_tasks INTEGER DEFAULT 0,
  completed_tasks INTEGER DEFAULT 0,
  
  -- Status
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'on_leave')),
  join_date DATE,
  leave_date DATE,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(user_id)
);

CREATE INDEX idx_staff_user_id ON staff(user_id);
CREATE INDEX idx_staff_department_id ON staff(department_id);
CREATE INDEX idx_staff_role ON staff(role);
CREATE INDEX idx_staff_status ON staff(status) WHERE status = 'active';
```

**Purpose**: Thông tin chi tiết nhân viên tòa soạn

---

### **3. departments** (Phòng ban)

```sql
CREATE TABLE departments (
  -- Primary Key
  id VARCHAR(50) PRIMARY KEY, -- e.g., 'phong-ban-doc', 'phong-kinh-te'
  
  -- Basic Info
  name VARCHAR(100) NOT NULL,
  name_en VARCHAR(100),
  description TEXT,
  
  -- Leadership
  leader_id UUID REFERENCES staff(id) ON DELETE SET NULL,
  deputy_leader_id UUID REFERENCES staff(id) ON DELETE SET NULL,
  
  -- Stats
  member_count INTEGER DEFAULT 0,
  active_tasks INTEGER DEFAULT 0,
  completed_tasks INTEGER DEFAULT 0,
  
  -- Contact
  email VARCHAR(255),
  phone VARCHAR(20),
  location VARCHAR(255),
  
  -- Status
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_departments_leader_id ON departments(leader_id);
CREATE INDEX idx_departments_status ON departments(status);
```

**Sample IDs**:
```
- ban-bien-tap (Ban Biên tập)
- phong-ban-doc (Phòng Bạn đọc và Công tác xã hội)
- phong-kinh-te (Phòng Kinh tế)
- phong-cong-nghiep (Phòng Công nghiệp - Xây dựng)
- phong-thuong-mai (Phòng Thương mại - Dịch vụ)
- ... (total 13 departments)
```

---

### **4. tasks** (Công việc)

```sql
CREATE TABLE tasks (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Basic Info
  title VARCHAR(255) NOT NULL,
  description TEXT,
  
  -- Status & Priority
  status VARCHAR(20) DEFAULT 'pending' CHECK (
    status IN ('pending', 'in_progress', 'review', 'completed', 'cancelled', 'on_hold')
  ),
  priority VARCHAR(20) DEFAULT 'medium' CHECK (
    priority IN ('low', 'medium', 'high', 'urgent')
  ),
  
  -- Categories (Multi-select)
  categories TEXT[] DEFAULT '{}', -- Array of category IDs
  
  -- Assignment
  created_by UUID NOT NULL REFERENCES users(id),
  department_id VARCHAR(50) REFERENCES departments(id),
  
  -- Dates
  start_date DATE,
  due_date DATE,
  completed_at TIMESTAMP WITH TIME ZONE,
  
  -- Approval Workflow
  approval_status VARCHAR(20) DEFAULT 'pending' CHECK (
    approval_status IN ('pending', 'approved', 'rejected', 'revision_requested')
  ),
  approved_by UUID REFERENCES users(id),
  approved_at TIMESTAMP WITH TIME ZONE,
  approval_notes TEXT,
  
  -- Metadata
  estimated_hours DECIMAL(5,2),
  actual_hours DECIMAL(5,2),
  progress INTEGER DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  
  -- Additional Fields
  tags TEXT[], -- Free-form tags
  attachments_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  CHECK (due_date IS NULL OR due_date >= start_date)
);

CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_created_by ON tasks(created_by);
CREATE INDEX idx_tasks_department_id ON tasks(department_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_categories ON tasks USING GIN(categories);
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);
```

**Categories Array Example**:
```json
["trung_uong", "media", "seo"]
```

---

### **5. task_assignments** (Gán người làm)

```sql
CREATE TABLE task_assignments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Links
  task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Assignment Details
  role VARCHAR(20) DEFAULT 'assignee' CHECK (
    role IN ('assignee', 'reviewer', 'observer', 'approver')
  ),
  
  -- Status
  status VARCHAR(20) DEFAULT 'active' CHECK (
    status IN ('active', 'completed', 'removed')
  ),
  
  -- Dates
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  assigned_by UUID REFERENCES users(id),
  completed_at TIMESTAMP WITH TIME ZONE,
  
  -- Constraints
  UNIQUE(task_id, user_id, role)
);

CREATE INDEX idx_task_assignments_task_id ON task_assignments(task_id);
CREATE INDEX idx_task_assignments_user_id ON task_assignments(user_id);
CREATE INDEX idx_task_assignments_status ON task_assignments(status);
```

---

### **6. task_comments** (Bình luận)

```sql
CREATE TABLE task_comments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Links
  task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Content
  content TEXT NOT NULL,
  
  -- Threading (optional)
  parent_id UUID REFERENCES task_comments(id) ON DELETE CASCADE,
  
  -- Metadata
  is_internal BOOLEAN DEFAULT false, -- Internal note vs public comment
  edited BOOLEAN DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_task_comments_task_id ON task_comments(task_id);
CREATE INDEX idx_task_comments_user_id ON task_comments(user_id);
CREATE INDEX idx_task_comments_parent_id ON task_comments(parent_id);
CREATE INDEX idx_task_comments_created_at ON task_comments(created_at DESC);
```

---

### **7. task_attachments** (Đính kèm)

```sql
CREATE TABLE task_attachments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Links
  task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  uploaded_by UUID NOT NULL REFERENCES users(id),
  
  -- File Info
  file_name VARCHAR(255) NOT NULL,
  file_type VARCHAR(100), -- MIME type
  file_size INTEGER, -- bytes
  file_url TEXT NOT NULL, -- Supabase Storage URL
  
  -- Metadata
  description TEXT,
  
  -- Timestamps
  uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_task_attachments_task_id ON task_attachments(task_id);
CREATE INDEX idx_task_attachments_uploaded_by ON task_attachments(uploaded_by);
```

---

### **8. task_categories** (Reference Data)

```sql
CREATE TABLE task_categories (
  -- Primary Key
  id VARCHAR(50) PRIMARY KEY,
  
  -- Display
  label VARCHAR(100) NOT NULL,
  color VARCHAR(7) NOT NULL, -- Hex color: #DC2626
  icon VARCHAR(10), -- Emoji: 🏛️
  
  -- Details
  description TEXT,
  
  -- Status
  enabled BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_task_categories_enabled ON task_categories(enabled) WHERE enabled = true;
```

**Pre-populated Data** (8 categories):
```
trung_uong, bo_nganh_dia_phuong, media, chuyen_trang, 
chuyen_muc, mang_xa_hoi, ven, seo
```

---

### **9. articles** (Bài viết)

```sql
CREATE TABLE articles (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Content
  title VARCHAR(500) NOT NULL,
  content TEXT,
  summary TEXT,
  
  -- Status
  status VARCHAR(20) DEFAULT 'draft' CHECK (
    status IN ('draft', 'review', 'approved', 'published', 'archived')
  ),
  
  -- Author & Editor
  author_id UUID NOT NULL REFERENCES users(id),
  editor_id UUID REFERENCES users(id),
  
  -- Category & Classification
  category VARCHAR(100),
  subcategory VARCHAR(100),
  tags TEXT[],
  
  -- SEO
  keywords TEXT[],
  meta_description TEXT,
  seo_score INTEGER CHECK (seo_score >= 0 AND seo_score <= 100),
  
  -- Publishing
  published_at TIMESTAMP WITH TIME ZONE,
  scheduled_for TIMESTAMP WITH TIME ZONE,
  
  -- Source (if generated from scan)
  source_url TEXT,
  scan_id UUID REFERENCES scans(id),
  
  -- Metrics
  view_count INTEGER DEFAULT 0,
  share_count INTEGER DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_articles_author_id ON articles(author_id);
CREATE INDEX idx_articles_published_at ON articles(published_at DESC);
CREATE INDEX idx_articles_keywords ON articles USING GIN(keywords);
CREATE INDEX idx_articles_category ON articles(category);
```

---

### **10. scans** (Quét tin tức)

```sql
CREATE TABLE scans (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Source
  url TEXT NOT NULL,
  source VARCHAR(255), -- Domain or site name
  
  -- Content
  title VARCHAR(500),
  content TEXT,
  summary TEXT,
  
  -- Scan Info
  scan_type VARCHAR(20) DEFAULT 'auto' CHECK (scan_type IN ('auto', 'manual')),
  status VARCHAR(20) DEFAULT 'pending' CHECK (
    status IN ('pending', 'processing', 'completed', 'failed')
  ),
  
  -- Results
  keywords TEXT[],
  sentiment VARCHAR(20), -- positive, negative, neutral
  relevance_score DECIMAL(3,2), -- 0.00 to 1.00
  
  -- Error Info
  error_message TEXT,
  retry_count INTEGER DEFAULT 0,
  
  -- User
  triggered_by UUID REFERENCES users(id),
  
  -- Timestamps
  scanned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_scans_status ON scans(status);
CREATE INDEX idx_scans_url ON scans(url);
CREATE INDEX idx_scans_scanned_at ON scans(scanned_at DESC);
CREATE INDEX idx_scans_source ON scans(source);
```

---

### **11. schedules** (Lịch quét)

```sql
CREATE TABLE schedules (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Schedule Info
  name VARCHAR(255) NOT NULL,
  description TEXT,
  
  -- Target
  url TEXT NOT NULL,
  source VARCHAR(255),
  
  -- Frequency
  frequency VARCHAR(20) NOT NULL CHECK (
    frequency IN ('hourly', 'daily', 'weekly', 'monthly', 'custom')
  ),
  cron_expression VARCHAR(100), -- For custom frequency
  
  -- Status
  enabled BOOLEAN DEFAULT true,
  
  -- Last Run
  last_run_at TIMESTAMP WITH TIME ZONE,
  last_run_status VARCHAR(20),
  next_run_at TIMESTAMP WITH TIME ZONE,
  
  -- Stats
  total_runs INTEGER DEFAULT 0,
  successful_runs INTEGER DEFAULT 0,
  failed_runs INTEGER DEFAULT 0,
  
  -- Creator
  created_by UUID NOT NULL REFERENCES users(id),
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_schedules_enabled ON schedules(enabled) WHERE enabled = true;
CREATE INDEX idx_schedules_next_run_at ON schedules(next_run_at);
CREATE INDEX idx_schedules_created_by ON schedules(created_by);
```

---

### **12. ai_chat_messages** (AI Chat History)

```sql
CREATE TABLE ai_chat_messages (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- User
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Conversation
  session_id UUID, -- Group messages in same chat session
  
  -- Content
  message TEXT NOT NULL, -- User's question
  response TEXT NOT NULL, -- AI's answer
  
  -- AI Config
  model VARCHAR(50) DEFAULT 'gpt-4o-mini',
  temperature DECIMAL(2,1) DEFAULT 0.7,
  
  -- Tokens
  tokens_input INTEGER,
  tokens_output INTEGER,
  tokens_total INTEGER,
  
  -- Cost
  cost_usd DECIMAL(10,6),
  
  -- Feedback
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  feedback TEXT,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_ai_chat_messages_user_id ON ai_chat_messages(user_id);
CREATE INDEX idx_ai_chat_messages_session_id ON ai_chat_messages(session_id);
CREATE INDEX idx_ai_chat_messages_created_at ON ai_chat_messages(created_at DESC);
```

---

### **13. ai_usage_logs** (AI Usage Tracking)

```sql
CREATE TABLE ai_usage_logs (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- User
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Action
  action VARCHAR(50) NOT NULL CHECK (
    action IN (
      'chat',
      'generate_article',
      'scan_url',
      'summarize',
      'translate',
      'seo_optimize',
      'rewrite',
      'expand',
      'other'
    )
  ),
  
  -- AI Config
  model VARCHAR(50) NOT NULL,
  provider VARCHAR(50) DEFAULT 'openai', -- openai, anthropic, google, etc.
  
  -- Tokens
  tokens_input INTEGER DEFAULT 0,
  tokens_output INTEGER DEFAULT 0,
  tokens_total INTEGER GENERATED ALWAYS AS (tokens_input + tokens_output) STORED,
  
  -- Cost
  cost_usd DECIMAL(10,6),
  
  -- Metadata
  metadata JSONB, -- Flexible field for additional info
  
  -- Resource Link
  resource_type VARCHAR(50), -- 'task', 'article', 'scan'
  resource_id UUID,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_ai_usage_logs_user_id ON ai_usage_logs(user_id);
CREATE INDEX idx_ai_usage_logs_action ON ai_usage_logs(action);
CREATE INDEX idx_ai_usage_logs_created_at ON ai_usage_logs(created_at DESC);
CREATE INDEX idx_ai_usage_logs_resource ON ai_usage_logs(resource_type, resource_id);
```

---

### **14. permissions** (Phân quyền chi tiết)

```sql
CREATE TABLE permissions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- User
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Resource
  resource VARCHAR(100) NOT NULL, -- 'tasks', 'articles', 'users', 'departments'
  
  -- Actions (array of allowed actions)
  actions TEXT[] DEFAULT '{}', -- ['create', 'read', 'update', 'delete', 'approve']
  
  -- Scope
  scope VARCHAR(20) DEFAULT 'all' CHECK (
    scope IN ('all', 'own', 'department', 'custom')
  ),
  scope_value TEXT, -- Department ID or custom filter
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(user_id, resource)
);

CREATE INDEX idx_permissions_user_id ON permissions(user_id);
CREATE INDEX idx_permissions_resource ON permissions(resource);
```

**Sample Permission**:
```json
{
  "user_id": "123...",
  "resource": "tasks",
  "actions": ["create", "read", "update", "delete", "approve"],
  "scope": "department",
  "scope_value": "phong-kinh-te"
}
```

---

### **15. audit_logs** (Audit Trail)

```sql
CREATE TABLE audit_logs (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- User
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  username VARCHAR(50), -- Cached for deleted users
  
  -- Action
  action VARCHAR(50) NOT NULL, -- 'create', 'update', 'delete', 'login', etc.
  
  -- Resource
  resource_type VARCHAR(50) NOT NULL, -- 'task', 'user', 'article', etc.
  resource_id UUID,
  
  -- Changes (JSON diff)
  changes JSONB,
  
  -- Request Info
  ip_address INET,
  user_agent TEXT,
  
  -- Status
  status VARCHAR(20) DEFAULT 'success' CHECK (status IN ('success', 'failure')),
  error_message TEXT,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_resource ON audit_logs(resource_type, resource_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at DESC);
```

---

### **16. system_config** (Cấu hình hệ thống)

```sql
CREATE TABLE system_config (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Key-Value
  key VARCHAR(100) UNIQUE NOT NULL,
  value JSONB NOT NULL,
  
  -- Metadata
  category VARCHAR(50), -- 'ai', 'theme', 'notification', 'security'
  description TEXT,
  
  -- Validation
  data_type VARCHAR(20) DEFAULT 'string' CHECK (
    data_type IN ('string', 'number', 'boolean', 'object', 'array')
  ),
  is_public BOOLEAN DEFAULT false, -- Can be accessed by non-admin?
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_system_config_category ON system_config(category);
CREATE INDEX idx_system_config_is_public ON system_config(is_public);
```

**Sample Configs**:
```json
{
  "key": "ai.openai_api_key",
  "value": "sk-...",
  "category": "ai",
  "is_public": false
}

{
  "key": "theme.primary_color",
  "value": "#0066CC",
  "category": "theme",
  "is_public": true
}
```

---

### **17. notifications** (Thông báo - Optional)

```sql
CREATE TABLE notifications (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Recipient
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Content
  title VARCHAR(255) NOT NULL,
  message TEXT,
  type VARCHAR(20) DEFAULT 'info' CHECK (
    type IN ('info', 'success', 'warning', 'error')
  ),
  
  -- Action Link
  action_url TEXT,
  action_text VARCHAR(100),
  
  -- Status
  read BOOLEAN DEFAULT false,
  read_at TIMESTAMP WITH TIME ZONE,
  
  -- Related Resource
  resource_type VARCHAR(50),
  resource_id UUID,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(read) WHERE read = false;
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
```

---

## 🔗 **RELATIONSHIPS**

### **Entity Relationship Diagram**:

```
users ──┬──< staff (1:1)
        ├──< permissions (1:M)
        ├──< tasks (1:M, created_by)
        ├──< task_assignments (1:M)
        ├──< task_comments (1:M)
        ├──< articles (1:M)
        ├──< ai_chat_messages (1:M)
        ├──< ai_usage_logs (1:M)
        └──< audit_logs (1:M)

departments ──┬──< staff (1:M)
              ├──< tasks (1:M)
              └──○ leader_id (staff.id)

tasks ──┬──< task_assignments (1:M)
        ├──< task_comments (1:M)
        └──< task_attachments (1:M)

scans ──< articles (1:M, optional)
```

### **Foreign Keys Summary**:

| Child Table         | Foreign Key          | Parent Table  | On Delete      |
|---------------------|----------------------|---------------|----------------|
| staff               | user_id              | users         | CASCADE        |
| staff               | department_id        | departments   | SET NULL       |
| departments         | leader_id            | staff         | SET NULL       |
| tasks               | created_by           | users         | RESTRICT       |
| tasks               | department_id        | departments   | SET NULL       |
| task_assignments    | task_id              | tasks         | CASCADE        |
| task_assignments    | user_id              | users         | CASCADE        |
| task_comments       | task_id              | tasks         | CASCADE        |
| task_comments       | user_id              | users         | CASCADE        |
| task_attachments    | task_id              | tasks         | CASCADE        |
| task_attachments    | uploaded_by          | users         | RESTRICT       |
| articles            | author_id            | users         | RESTRICT       |
| articles            | scan_id              | scans         | SET NULL       |
| scans               | triggered_by         | users         | SET NULL       |
| schedules           | created_by           | users         | RESTRICT       |
| ai_chat_messages    | user_id              | users         | CASCADE        |
| ai_usage_logs       | user_id              | users         | CASCADE        |
| permissions         | user_id              | users         | CASCADE        |
| audit_logs          | user_id              | users         | SET NULL       |
| notifications       | user_id              | users         | CASCADE        |

---

## 📊 **INDEXES**

### **Performance Indexes**:

```sql
-- Users
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- Staff
CREATE INDEX idx_staff_user_id ON staff(user_id);
CREATE INDEX idx_staff_department_id ON staff(department_id);
CREATE INDEX idx_staff_status ON staff(status) WHERE status = 'active';

-- Tasks (Critical for performance)
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_department_id ON tasks(department_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);
CREATE INDEX idx_tasks_categories ON tasks USING GIN(categories); -- Array index

-- Task Assignments
CREATE INDEX idx_task_assignments_task_id ON task_assignments(task_id);
CREATE INDEX idx_task_assignments_user_id ON task_assignments(user_id);

-- Articles
CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_articles_author_id ON articles(author_id);
CREATE INDEX idx_articles_published_at ON articles(published_at DESC);
CREATE INDEX idx_articles_keywords ON articles USING GIN(keywords);

-- AI Usage
CREATE INDEX idx_ai_usage_logs_user_id ON ai_usage_logs(user_id);
CREATE INDEX idx_ai_usage_logs_created_at ON ai_usage_logs(created_at DESC);

-- Audit Logs
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at DESC);
```

---

## 🔒 **ROW LEVEL SECURITY (RLS)**

### **Enable RLS on all tables**:

```sql
-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE scans ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_usage_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_config ENABLE ROW LEVEL SECURITY;
```

### **RLS Policies**:

#### **1. Users Table**:

```sql
-- Admin có thể xem tất cả users
CREATE POLICY "Admins can view all users"
  ON users FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = auth.uid() AND u.role = 'Admin'
    )
  );

-- Users có thể xem profile của chính mình
CREATE POLICY "Users can view their own profile"
  ON users FOR SELECT
  TO authenticated
  USING (id = auth.uid());

-- Admin có thể update users
CREATE POLICY "Admins can update users"
  ON users FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = auth.uid() AND u.role = 'Admin'
    )
  );

-- Users có thể update profile của chính mình
CREATE POLICY "Users can update their own profile"
  ON users FOR UPDATE
  TO authenticated
  USING (id = auth.uid());
```

#### **2. Tasks Table**:

```sql
-- Everyone can read tasks trong department của mình
CREATE POLICY "Users can view department tasks"
  ON tasks FOR SELECT
  TO authenticated
  USING (
    department_id IN (
      SELECT department_id FROM staff
      WHERE user_id = auth.uid()
    )
    OR
    created_by = auth.uid()
    OR
    EXISTS (
      SELECT 1 FROM task_assignments
      WHERE task_id = tasks.id AND user_id = auth.uid()
    )
  );

-- Writer+ có thể tạo tasks
CREATE POLICY "Writers can create tasks"
  ON tasks FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role IN ('Admin', 'Writer')
    )
  );

-- Task creator hoặc assignee có thể update
CREATE POLICY "Task owners can update"
  ON tasks FOR UPDATE
  TO authenticated
  USING (
    created_by = auth.uid()
    OR
    EXISTS (
      SELECT 1 FROM task_assignments
      WHERE task_id = tasks.id AND user_id = auth.uid()
    )
  );

-- Admin có thể xóa tasks
CREATE POLICY "Admins can delete tasks"
  ON tasks FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'Admin'
    )
  );
```

#### **3. AI Chat Messages**:

```sql
-- Users chỉ xem được chat của mình
CREATE POLICY "Users can view their own chats"
  ON ai_chat_messages FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Users có thể tạo chat messages
CREATE POLICY "Users can create chat messages"
  ON ai_chat_messages FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Admin có thể xem tất cả chats
CREATE POLICY "Admins can view all chats"
  ON ai_chat_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'Admin'
    )
  );
```

#### **4. System Config**:

```sql
-- Admin toàn quyền
CREATE POLICY "Admins full access to system_config"
  ON system_config FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'Admin'
    )
  );

-- Public configs: everyone can read
CREATE POLICY "Everyone can read public configs"
  ON system_config FOR SELECT
  TO authenticated
  USING (is_public = true);
```

---

## 📦 **SAMPLE DATA**

### **1. Users (80 accounts)**:

```sql
-- Admin account
INSERT INTO users (id, username, email, full_name, role, password_hash) VALUES
('00000000-0000-0000-0000-000000000080', 'admin', 'admin@baocongthuong.vn', 'System Admin', 'Admin', '$2b$10$...');

-- Tổng Biên tập
INSERT INTO users (id, username, email, full_name, role, password_hash) VALUES
('00000000-0000-0000-0000-000000000001', 'nguyenvanminh', 'chichco6868@gmail.com', 'Nguyễn Văn Minh', 'Admin', '$2b$10$...');

-- Staff (78 accounts)
INSERT INTO users (id, username, email, full_name, role, password_hash) VALUES
('00000000-0000-0000-0000-000000000002', 'vananhthai', 'vananhthai02@gmail.com', 'Thái Thị Vân Anh', 'Writer', '$2b$10$...'),
('00000000-0000-0000-0000-000000000003', 'nguyenvanthi', 'nguyenvanthi@baocongthuong.vn', 'Nguyễn Văn Thi', 'Writer', '$2b$10$...'),
-- ... (76 more)
```

**Password Hashes** (bcrypt):
- Admin: `dunghoi123` → bcrypt hash
- All staff: `btc2025` → bcrypt hash

### **2. Departments (13 phòng ban)**:

```sql
INSERT INTO departments (id, name, name_en, member_count) VALUES
('ban-bien-tap', 'Ban Biên tập', 'Editorial Board', 1),
('phong-ban-doc', 'Phòng Bạn đọc và Công tác xã hội', 'Reader Affairs Department', 6),
('phong-kinh-te', 'Phòng Kinh tế', 'Economics Department', 6),
('phong-cong-nghiep', 'Phòng Công nghiệp - Xây dựng', 'Industry & Construction Department', 6),
('phong-thuong-mai', 'Phòng Thương mại - Dịch vụ', 'Trade & Services Department', 6),
('phong-quang-cao', 'Phòng Quảng cáo', 'Advertising Department', 7),
('phong-thi-truong', 'Phòng Thị trường - Pháp chế', 'Market & Legal Department', 6),
('phong-khcn', 'Phòng Khoa học Công nghệ', 'Science & Technology Department', 6),
('phong-ky-thuat', 'Phòng Kỹ thuật - Đa phương tiện', 'Technical & Multimedia Department', 6),
('phong-anh', 'Phòng Ảnh', 'Photography Department', 6),
('phong-tckt', 'Phòng Tài chính kế toán', 'Finance & Accounting Department', 6),
('phong-hanh-chinh', 'Phòng Hành chính - Tổ chức', 'Administration Department', 6),
('phong-tcbh', 'Phòng Tư liệu - Bảo hiểm', 'Archive & Insurance Department', 6);
```

### **3. Staff (80 entries)**:

```sql
-- Tổng Biên tập
INSERT INTO staff (id, user_id, position, department_id, role, active_tasks, completed_tasks, status, join_date) VALUES
('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Tổng Biên tập', 'ban-bien-tap', 'editor_in_chief', 5, 247, 'active', '2020-01-01');

-- Staff examples
INSERT INTO staff (id, user_id, position, department_id, role, active_tasks, completed_tasks, status, join_date) VALUES
('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'Phóng viên', 'phong-ban-doc', 'reporter', 3, 45, 'active', '2022-03-15'),
('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', 'Biên tập viên', 'phong-ban-doc', 'editor', 2, 38, 'active', '2021-06-10');
-- ... (77 more)
```

### **4. Task Categories (8 categories)**:

```sql
INSERT INTO task_categories (id, label, color, icon, description, enabled, sort_order) VALUES
('trung_uong', 'Trung ương', '#DC2626', '🏛️', 'Tin tức về lãnh đạo Đảng, Nhà nước, sự kiện quan trọng', true, 1),
('bo_nganh_dia_phuong', 'Bộ ngành, địa phương', '#2563EB', '🏢', 'Làm việc với các cơ quan, đơn vị, địa phương', true, 2),
('media', 'Media', '#7C3AED', '🎬', 'Quay phim, dựng video, phóng sự, sản xuất nội dung đa phương tiện', true, 3),
('chuyen_trang', 'Chuyên trang', '#059669', '📰', 'Nội dung chuyên trang chuyên biệt', true, 4),
('chuyen_muc', 'Chuyên mục', '#D97706', '📝', 'Nội dung chuyên mục cố định, định kỳ', true, 5),
('mang_xa_hoi', 'Mạng xã hội', '#DB2777', '📱', 'TikTok, Facebook, YouTube, Zalo OA, Instagram', true, 6),
('ven', 'Ven', '#0891B2', '🌐', 'Nội dung Ven', true, 7),
('seo', 'SEO', '#16A34A', '🔍', 'Tối ưu SEO, keywords, traffic, backlink', true, 8);
```

### **5. Sample Tasks (10 examples)**:

```sql
INSERT INTO tasks (id, title, description, status, priority, categories, created_by, department_id, due_date) VALUES
(
  '10000000-0000-0000-0000-000000000001',
  'Phỏng vấn Bộ trưởng Bộ Công Thương về chính sách mới',
  'Chuẩn bị câu hỏi và lên lịch phỏng vấn',
  'in_progress',
  'high',
  ARRAY['trung_uong', 'media'],
  '00000000-0000-0000-0000-000000000001',
  'phong-kinh-te',
  '2025-10-30'
),
(
  '10000000-0000-0000-0000-000000000002',
  'Viết bài về triển lãm thương mại quốc tế',
  'Tham dự sự kiện và viết bài',
  'pending',
  'medium',
  ARRAY['bo_nganh_dia_phuong', 'chuyen_trang'],
  '00000000-0000-0000-0000-000000000002',
  'phong-thuong-mai',
  '2025-10-28'
),
(
  '10000000-0000-0000-0000-000000000003',
  'Quay video TikTok về khởi nghiệp',
  'Series video ngắn về các startup Việt Nam',
  'in_progress',
  'high',
  ARRAY['media', 'mang_xa_hoi'],
  '00000000-0000-0000-0000-000000000003',
  'phong-ky-thuat',
  '2025-10-25'
),
(
  '10000000-0000-0000-0000-000000000004',
  'Tối ưu SEO cho các bài viết tháng 10',
  'Audit và optimize keywords, meta descriptions',
  'pending',
  'medium',
  ARRAY['seo'],
  '00000000-0000-0000-0000-000000000004',
  'phong-ky-thuat',
  '2025-10-31'
);
-- ... (more tasks)
```

---

## 🚀 **MIGRATION SCRIPTS**

### **Full Migration SQL**:

Save as: `001_initial_schema.sql`

```sql
-- ========================================
-- DOCNHANH - BÁO CÔNG THƯƠNG
-- Initial Database Schema
-- Version: 1.0
-- Date: 2025-10-23
-- ========================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For text search

-- ========================================
-- 1. USERS & AUTHENTICATION
-- ========================================

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  avatar_url TEXT,
  phone VARCHAR(20),
  address TEXT,
  bio TEXT,
  role VARCHAR(20) NOT NULL DEFAULT 'Writer' CHECK (role IN ('Admin', 'Writer', 'View')),
  disabled BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- ========================================
-- 2. DEPARTMENTS
-- ========================================

CREATE TABLE departments (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  name_en VARCHAR(100),
  description TEXT,
  leader_id UUID,
  deputy_leader_id UUID,
  member_count INTEGER DEFAULT 0,
  active_tasks INTEGER DEFAULT 0,
  completed_tasks INTEGER DEFAULT 0,
  email VARCHAR(255),
  phone VARCHAR(20),
  location VARCHAR(255),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_departments_leader_id ON departments(leader_id);
CREATE INDEX idx_departments_status ON departments(status);

-- ========================================
-- 3. STAFF
-- ========================================

CREATE TABLE staff (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  staff_code VARCHAR(20) UNIQUE,
  position VARCHAR(100) NOT NULL,
  department_id VARCHAR(50) REFERENCES departments(id) ON DELETE SET NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'staff' CHECK (
    role IN ('editor_in_chief', 'department_head', 'deputy_head', 'secretary', 'reporter', 'editor', 'staff')
  ),
  active_tasks INTEGER DEFAULT 0,
  completed_tasks INTEGER DEFAULT 0,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'on_leave')),
  join_date DATE,
  leave_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX idx_staff_user_id ON staff(user_id);
CREATE INDEX idx_staff_department_id ON staff(department_id);
CREATE INDEX idx_staff_role ON staff(role);

-- Add foreign keys for department leaders
ALTER TABLE departments ADD CONSTRAINT fk_departments_leader 
  FOREIGN KEY (leader_id) REFERENCES staff(id) ON DELETE SET NULL;
ALTER TABLE departments ADD CONSTRAINT fk_departments_deputy_leader 
  FOREIGN KEY (deputy_leader_id) REFERENCES staff(id) ON DELETE SET NULL;

-- ========================================
-- 4. TASK CATEGORIES
-- ========================================

CREATE TABLE task_categories (
  id VARCHAR(50) PRIMARY KEY,
  label VARCHAR(100) NOT NULL,
  color VARCHAR(7) NOT NULL,
  icon VARCHAR(10),
  description TEXT,
  enabled BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_task_categories_enabled ON task_categories(enabled) WHERE enabled = true;

-- ========================================
-- 5. TASKS
-- ========================================

CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(20) DEFAULT 'pending' CHECK (
    status IN ('pending', 'in_progress', 'review', 'completed', 'cancelled', 'on_hold')
  ),
  priority VARCHAR(20) DEFAULT 'medium' CHECK (
    priority IN ('low', 'medium', 'high', 'urgent')
  ),
  categories TEXT[] DEFAULT '{}',
  created_by UUID NOT NULL REFERENCES users(id),
  department_id VARCHAR(50) REFERENCES departments(id),
  start_date DATE,
  due_date DATE,
  completed_at TIMESTAMP WITH TIME ZONE,
  approval_status VARCHAR(20) DEFAULT 'pending' CHECK (
    approval_status IN ('pending', 'approved', 'rejected', 'revision_requested')
  ),
  approved_by UUID REFERENCES users(id),
  approved_at TIMESTAMP WITH TIME ZONE,
  approval_notes TEXT,
  estimated_hours DECIMAL(5,2),
  actual_hours DECIMAL(5,2),
  progress INTEGER DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  tags TEXT[],
  attachments_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CHECK (due_date IS NULL OR due_date >= start_date)
);

CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_created_by ON tasks(created_by);
CREATE INDEX idx_tasks_department_id ON tasks(department_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_categories ON tasks USING GIN(categories);
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);

-- ========================================
-- 6. TASK ASSIGNMENTS
-- ========================================

CREATE TABLE task_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(20) DEFAULT 'assignee' CHECK (
    role IN ('assignee', 'reviewer', 'observer', 'approver')
  ),
  status VARCHAR(20) DEFAULT 'active' CHECK (
    status IN ('active', 'completed', 'removed')
  ),
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  assigned_by UUID REFERENCES users(id),
  completed_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(task_id, user_id, role)
);

CREATE INDEX idx_task_assignments_task_id ON task_assignments(task_id);
CREATE INDEX idx_task_assignments_user_id ON task_assignments(user_id);

-- ========================================
-- 7. TASK COMMENTS
-- ========================================

CREATE TABLE task_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  parent_id UUID REFERENCES task_comments(id) ON DELETE CASCADE,
  is_internal BOOLEAN DEFAULT false,
  edited BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_task_comments_task_id ON task_comments(task_id);
CREATE INDEX idx_task_comments_user_id ON task_comments(user_id);
CREATE INDEX idx_task_comments_created_at ON task_comments(created_at DESC);

-- ========================================
-- 8. TASK ATTACHMENTS
-- ========================================

CREATE TABLE task_attachments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  uploaded_by UUID NOT NULL REFERENCES users(id),
  file_name VARCHAR(255) NOT NULL,
  file_type VARCHAR(100),
  file_size INTEGER,
  file_url TEXT NOT NULL,
  description TEXT,
  uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_task_attachments_task_id ON task_attachments(task_id);

-- ========================================
-- 9. ARTICLES
-- ========================================

CREATE TABLE articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(500) NOT NULL,
  content TEXT,
  summary TEXT,
  status VARCHAR(20) DEFAULT 'draft' CHECK (
    status IN ('draft', 'review', 'approved', 'published', 'archived')
  ),
  author_id UUID NOT NULL REFERENCES users(id),
  editor_id UUID REFERENCES users(id),
  category VARCHAR(100),
  subcategory VARCHAR(100),
  tags TEXT[],
  keywords TEXT[],
  meta_description TEXT,
  seo_score INTEGER CHECK (seo_score >= 0 AND seo_score <= 100),
  published_at TIMESTAMP WITH TIME ZONE,
  scheduled_for TIMESTAMP WITH TIME ZONE,
  source_url TEXT,
  view_count INTEGER DEFAULT 0,
  share_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_articles_author_id ON articles(author_id);
CREATE INDEX idx_articles_published_at ON articles(published_at DESC);
CREATE INDEX idx_articles_keywords ON articles USING GIN(keywords);

-- ========================================
-- 10. SCANS
-- ========================================

CREATE TABLE scans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  url TEXT NOT NULL,
  source VARCHAR(255),
  title VARCHAR(500),
  content TEXT,
  summary TEXT,
  scan_type VARCHAR(20) DEFAULT 'auto' CHECK (scan_type IN ('auto', 'manual')),
  status VARCHAR(20) DEFAULT 'pending' CHECK (
    status IN ('pending', 'processing', 'completed', 'failed')
  ),
  keywords TEXT[],
  sentiment VARCHAR(20),
  relevance_score DECIMAL(3,2),
  error_message TEXT,
  retry_count INTEGER DEFAULT 0,
  triggered_by UUID REFERENCES users(id),
  scanned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_scans_status ON scans(status);
CREATE INDEX idx_scans_scanned_at ON scans(scanned_at DESC);

-- Add scan_id to articles
ALTER TABLE articles ADD COLUMN scan_id UUID REFERENCES scans(id);

-- ========================================
-- 11. SCHEDULES
-- ========================================

CREATE TABLE schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  url TEXT NOT NULL,
  source VARCHAR(255),
  frequency VARCHAR(20) NOT NULL CHECK (
    frequency IN ('hourly', 'daily', 'weekly', 'monthly', 'custom')
  ),
  cron_expression VARCHAR(100),
  enabled BOOLEAN DEFAULT true,
  last_run_at TIMESTAMP WITH TIME ZONE,
  last_run_status VARCHAR(20),
  next_run_at TIMESTAMP WITH TIME ZONE,
  total_runs INTEGER DEFAULT 0,
  successful_runs INTEGER DEFAULT 0,
  failed_runs INTEGER DEFAULT 0,
  created_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_schedules_enabled ON schedules(enabled) WHERE enabled = true;
CREATE INDEX idx_schedules_next_run_at ON schedules(next_run_at);

-- ========================================
-- 12. AI CHAT MESSAGES
-- ========================================

CREATE TABLE ai_chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID,
  message TEXT NOT NULL,
  response TEXT NOT NULL,
  model VARCHAR(50) DEFAULT 'gpt-4o-mini',
  temperature DECIMAL(2,1) DEFAULT 0.7,
  tokens_input INTEGER,
  tokens_output INTEGER,
  tokens_total INTEGER,
  cost_usd DECIMAL(10,6),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  feedback TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_ai_chat_messages_user_id ON ai_chat_messages(user_id);
CREATE INDEX idx_ai_chat_messages_session_id ON ai_chat_messages(session_id);
CREATE INDEX idx_ai_chat_messages_created_at ON ai_chat_messages(created_at DESC);

-- ========================================
-- 13. AI USAGE LOGS
-- ========================================

CREATE TABLE ai_usage_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  action VARCHAR(50) NOT NULL CHECK (
    action IN ('chat', 'generate_article', 'scan_url', 'summarize', 'translate', 'seo_optimize', 'rewrite', 'expand', 'other')
  ),
  model VARCHAR(50) NOT NULL,
  provider VARCHAR(50) DEFAULT 'openai',
  tokens_input INTEGER DEFAULT 0,
  tokens_output INTEGER DEFAULT 0,
  tokens_total INTEGER GENERATED ALWAYS AS (tokens_input + tokens_output) STORED,
  cost_usd DECIMAL(10,6),
  metadata JSONB,
  resource_type VARCHAR(50),
  resource_id UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_ai_usage_logs_user_id ON ai_usage_logs(user_id);
CREATE INDEX idx_ai_usage_logs_action ON ai_usage_logs(action);
CREATE INDEX idx_ai_usage_logs_created_at ON ai_usage_logs(created_at DESC);

-- ========================================
-- 14. PERMISSIONS
-- ========================================

CREATE TABLE permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  resource VARCHAR(100) NOT NULL,
  actions TEXT[] DEFAULT '{}',
  scope VARCHAR(20) DEFAULT 'all' CHECK (
    scope IN ('all', 'own', 'department', 'custom')
  ),
  scope_value TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, resource)
);

CREATE INDEX idx_permissions_user_id ON permissions(user_id);
CREATE INDEX idx_permissions_resource ON permissions(resource);

-- ========================================
-- 15. AUDIT LOGS
-- ========================================

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  username VARCHAR(50),
  action VARCHAR(50) NOT NULL,
  resource_type VARCHAR(50) NOT NULL,
  resource_id UUID,
  changes JSONB,
  ip_address INET,
  user_agent TEXT,
  status VARCHAR(20) DEFAULT 'success' CHECK (status IN ('success', 'failure')),
  error_message TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_resource ON audit_logs(resource_type, resource_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at DESC);

-- ========================================
-- 16. SYSTEM CONFIG
-- ========================================

CREATE TABLE system_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key VARCHAR(100) UNIQUE NOT NULL,
  value JSONB NOT NULL,
  category VARCHAR(50),
  description TEXT,
  data_type VARCHAR(20) DEFAULT 'string' CHECK (
    data_type IN ('string', 'number', 'boolean', 'object', 'array')
  ),
  is_public BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_system_config_category ON system_config(category);
CREATE INDEX idx_system_config_is_public ON system_config(is_public);

-- ========================================
-- 17. NOTIFICATIONS (Optional)
-- ========================================

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  message TEXT,
  type VARCHAR(20) DEFAULT 'info' CHECK (
    type IN ('info', 'success', 'warning', 'error')
  ),
  action_url TEXT,
  action_text VARCHAR(100),
  read BOOLEAN DEFAULT false,
  read_at TIMESTAMP WITH TIME ZONE,
  resource_type VARCHAR(50),
  resource_id UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(read) WHERE read = false;
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- ========================================
-- TRIGGERS & FUNCTIONS
-- ========================================

-- Auto update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_staff_updated_at BEFORE UPDATE ON staff
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_schedules_updated_at BEFORE UPDATE ON schedules
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- END OF SCHEMA
-- ========================================
```

---

## 🔌 **API ENDPOINTS MAPPING**

### **Mapping Backend API → Database Tables**:

| API Endpoint                      | HTTP Method | Database Table(s)        | Description              |
|-----------------------------------|-------------|--------------------------|--------------------------|
| `/api/v1/auth/login`              | POST        | users                    | Login authentication     |
| `/api/v1/auth/logout`             | POST        | users                    | Logout                   |
| `/api/v1/users/me`                | GET         | users, staff             | Get current user info    |
| `/api/v1/users`                   | GET         | users, staff             | List all users           |
| `/api/v1/users/{id}`              | GET         | users, staff             | Get user by ID           |
| `/api/v1/users`                   | POST        | users, staff             | Create new user          |
| `/api/v1/users/{id}`              | PUT         | users, staff             | Update user              |
| `/api/v1/users/{id}`              | DELETE      | users, staff             | Delete user              |
| `/api/v1/departments`             | GET         | departments              | List departments         |
| `/api/v1/departments/{id}`        | GET         | departments, staff       | Get department details   |
| `/api/v1/departments`             | POST        | departments              | Create department        |
| `/api/v1/tasks`                   | GET         | tasks, task_assignments  | List tasks (filtered)    |
| `/api/v1/tasks/{id}`              | GET         | tasks, assignments, comments | Get task details   |
| `/api/v1/tasks`                   | POST        | tasks                    | Create task              |
| `/api/v1/tasks/{id}`              | PUT         | tasks                    | Update task              |
| `/api/v1/tasks/{id}/assign`       | POST        | task_assignments         | Assign user to task      |
| `/api/v1/tasks/{id}/comments`     | POST        | task_comments            | Add comment              |
| `/api/v1/tasks/{id}/attachments`  | POST        | task_attachments         | Upload attachment        |
| `/api/v1/articles`                | GET         | articles                 | List articles            |
| `/api/v1/articles/{id}`           | GET         | articles                 | Get article              |
| `/api/v1/articles`                | POST        | articles                 | Create article           |
| `/api/v1/articles/{id}/publish`   | POST        | articles                 | Publish article          |
| `/api/v1/scans`                   | GET         | scans                    | List scans               |
| `/api/v1/scans`                   | POST        | scans                    | Trigger scan             |
| `/api/v1/schedules`               | GET         | schedules                | List schedules           |
| `/api/v1/schedules`               | POST        | schedules                | Create schedule          |
| `/api/v1/ai/chat`                 | POST        | ai_chat_messages, ai_usage_logs | Chat with AI    |
| `/api/v1/ai/usage`                | GET         | ai_usage_logs            | Get usage stats          |
| `/api/v1/audit-logs`              | GET         | audit_logs               | Get audit trail          |
| `/api/v1/config`                  | GET         | system_config            | Get system config        |
| `/api/v1/config/{key}`            | PUT         | system_config            | Update config            |

---

## ✅ **TESTING CHECKLIST**

### **Phase 1: Schema Validation**

```sql
-- ✅ 1. Check all tables created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Expected: 17 tables

-- ✅ 2. Check indexes
SELECT tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- ✅ 3. Check foreign keys
SELECT
  tc.table_name, 
  kcu.column_name, 
  ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;
```

### **Phase 2: Data Insertion**

```sql
-- ✅ 1. Insert test admin
INSERT INTO users (username, email, full_name, role, password_hash)
VALUES ('admin', 'admin@baocongthuong.vn', 'System Admin', 'Admin', '$2b$10$...');

-- ✅ 2. Insert departments
-- (Run departments INSERT script)

-- ✅ 3. Insert task categories
-- (Run task_categories INSERT script)

-- ✅ 4. Verify counts
SELECT 'users' AS table_name, COUNT(*) FROM users
UNION ALL
SELECT 'departments', COUNT(*) FROM departments
UNION ALL
SELECT 'task_categories', COUNT(*) FROM task_categories;
```

### **Phase 3: RLS Testing**

```sql
-- ✅ Enable RLS on all tables
-- (Run RLS enable script)

-- ✅ Create policies
-- (Run RLS policies script)

-- ✅ Test as different users
SET ROLE authenticated;
SET request.jwt.claim.sub = '00000000-0000-0000-0000-000000000001';
SELECT * FROM tasks; -- Should see own/department tasks only
```

### **Phase 4: API Integration**

```
✅ Login: POST /api/v1/auth/login
✅ Get user: GET /api/v1/users/me
✅ List tasks: GET /api/v1/tasks
✅ Create task: POST /api/v1/tasks
✅ Update task: PUT /api/v1/tasks/{id}
✅ AI Chat: POST /api/v1/ai/chat
```

---

## 📚 **DOCUMENTATION LINKS**

- **Full Schema SQL**: See Migration Scripts section above
- **Sample Data**: `002_sample_data.sql` (create separately)
- **RLS Policies**: See Row Level Security section
- **API Mapping**: See API Endpoints Mapping table

---

## 🎉 **SUMMARY**

```
✅ 17 Core Tables defined
✅ All relationships (FK) configured
✅ Indexes for performance
✅ Row Level Security policies
✅ Sample data structure (80 users, 13 departments, 8 categories)
✅ Migration scripts ready
✅ API endpoints mapped
✅ Testing checklist provided
```

---

**Ready for Backend Integration!** 🚀

**Next Steps**:
1. Run migration script in Supabase
2. Insert sample data (users, departments, categories)
3. Enable RLS and create policies
4. Test API endpoints
5. Verify data sync with frontend mock data

---

**END OF SCHEMA DOCUMENTATION**
