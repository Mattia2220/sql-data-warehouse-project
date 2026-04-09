# SQL Data Warehouse Project 🚀

![Data Model](data_model.png)

## 📌 Project Overview
Questo progetto illustra la progettazione e l'implementazione di un **Data Warehouse moderno** utilizzando **SQL Server**. L'obiettivo è trasformare dati grezzi provenienti da diverse sorgenti in insight aziendali pronti per l'analisi, seguendo le best practice di data engineering.

Il progetto copre l'intero ciclo di vita del dato:
* **ETL/ELT Processes**: Caricamento e trasformazione dei dati.
* **Data Modeling**: Implementazione di uno Star Schema (Fact e Dimension tables).
* **Data Analytics**: Creazione di un layer finale (Gold) ottimizzato per la reportistica.

---

## 🏗️ Medallion Architecture
Il data warehouse è strutturato in tre layer logici per garantire qualità e tracciabilità del dato:

1.  **Bronze Layer (Raw)**: Contiene i dati grezzi importati direttamente dai file sorgente (CSV).
2.  **Silver Layer (Cleansed)**: Fase di pulizia e standardizzazione. Qui vengono gestiti i valori nulli, i duplicati e i formati delle date.
3.  **Gold Layer (Analytical)**: Il layer finale dove i dati sono modellati secondo una struttura **Star Schema**, pronti per essere consumati da strumenti di BI come Power BI o Tableau.

---

## 📊 Data Model (Gold Layer)
Il cuore analitico del progetto è rappresentato dal **Sales Data Mart**. Come mostrato nel diagramma sopra, il modello si basa su:
* **Fact Table**: `gold.fact_sales` (contiene le metriche quantitative).
* **Dimension Tables**: `gold.dim_customers` e `gold.dim_products` (contengono gli attributi descrittivi).

---

## 📖 Data Catalog (Gold Layer)

Il Gold Layer è strutturato per supportare casi d'uso di business. Di seguito il dettaglio delle tabelle:

### 1️⃣ gold.dim_customers
* **Purpose:** Memorizza i dettagli dei clienti arricchiti con dati demografici e geografici.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **customer_key** | INT | Surrogate key univoca per il record (Primary Key). |
| customer_id | INT | Identificativo numerico originale del cliente. |
| customer_number | NVARCHAR(50) | Codice alfanumerico per il tracciamento. |
| first_name | NVARCHAR(50) | Nome del cliente. |
| last_name | NVARCHAR(50) | Cognome del cliente. |
| country | NVARCHAR(50) | Paese di residenza. |
| marital_status | NVARCHAR(50) | Stato civile (es. Married, Single). |
| gender | NVARCHAR(50) | Genere del cliente. |
| birthdate | DATE | Data di nascita (YYYY-MM-DD). |
| create_date | DATE | Data di creazione del record nel sistema. |

### 2️⃣ gold.dim_products
* **Purpose:** Fornisce informazioni dettagliate sui prodotti e i loro attributi.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **product_key** | INT | Surrogate key univoca per il prodotto (Primary Key). |
| product_id | INT | Identificativo interno del prodotto. |
| product_number | NVARCHAR(50) | Codice alfanumerico del prodotto. |
| product_name | NVARCHAR(50) | Nome descrittivo (include tipo, colore, taglia). |
| category_id | NVARCHAR(50) | ID della categoria di appartenenza. |
| category | NVARCHAR(50) | Classificazione macro (es. Bikes, Components). |
| subcategory | NVARCHAR(50) | Classificazione dettagliata del prodotto. |
| maintenance_required | NVARCHAR(50) | Indica se è richiesta manutenzione (Yes/No). |
| cost | INT | Costo base del prodotto. |
| product_line | NVARCHAR(50) | Linea di prodotti (es. Road, Mountain). |
| start_date | DATE | Data di messa in vendita. |

### 3️⃣ gold.fact_sales
* **Purpose:** Memorizza i dati transazionali delle vendite per scopi analitici.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| order_number | NVARCHAR(50) | Identificativo univoco dell'ordine (es. 'SO54496'). |
| **product_key** | INT | Foreign Key verso `gold.dim_products`. |
| **customer_key** | INT | Foreign Key verso `gold.dim_customers`. |
| order_date | DATE | Data in cui è stato effettuato l'ordine. |
| shipping_date | DATE | Data di spedizione. |
| due_date | DATE | Data di scadenza del pagamento. |
| sales_amount | INT | Valore monetario totale della vendita. |
| quantity | INT | Numero di unità ordinate. |
| price | INT | Prezzo unitario del prodotto. |

---

## 🛠️ Tech Stack
* **Database**: SQL Server
* **Modellazione**: Star Schema (Kimball Methodology)
* **Tool**: SQL Server Management Studio (SSMS)

---
