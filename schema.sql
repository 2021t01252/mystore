-- ============================================================
--  MyStore — Supabase Database Schema
--  Run this entire file in: Supabase Dashboard → SQL Editor
-- ============================================================

-- 1. PRODUCTS TABLE
create table if not exists products (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  price       numeric(12,2) not null,
  stock       integer not null default 0,
  description text,
  image       text,
  created_at  timestamptz default now()
);

-- 2. ORDERS TABLE
create table if not exists orders (
  id            uuid primary key default gen_random_uuid(),
  order_ref     text not null,
  buyer_name    text not null,
  buyer_city    text not null,
  buyer_address text not null,
  phone1        text not null,
  phone2        text not null,
  notes         text,
  items         jsonb not null default '[]',
  total_amount  numeric(12,2) not null,
  created_at    timestamptz default now()
);

-- 3. ROW LEVEL SECURITY (RLS)
--    Allow anyone to READ products (public store)
alter table products enable row level security;
create policy "Public can read products"
  on products for select using (true);

--    Allow anyone to INSERT products (admin does this via anon key)
create policy "Allow insert products"
  on products for insert with check (true);

--    Allow anyone to UPDATE products
create policy "Allow update products"
  on products for update using (true);

--    Allow anyone to DELETE products
create policy "Allow delete products"
  on products for delete using (true);

--    Allow anyone to INSERT orders (buyer submits)
alter table orders enable row level security;
create policy "Allow insert orders"
  on orders for insert with check (true);

--    Allow anyone to READ orders (admin reads them)
create policy "Allow read orders"
  on orders for select using (true);
