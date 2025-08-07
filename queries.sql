
-- Criação da coluna faixa_etaria e atribuição de valores com base na idade dos clientes
alter table  dados_bancarios add column faixa_etaria VARCHAR (20);

update  dados_bancarios
  set faixa_etaria = CASE
    WHEN age BETWEEN 19 AND 34 THEN '19-34'
    WHEN age BETWEEN 35 AND 49 THEN '35-49'
    WHEN age BETWEEN 50 AND 64 THEN '50-64'
    WHEN age >= 65 THEN '+65'
    ELSE 'Faixa desconhecida'
  END ;

-- Verificar se existe alguma relação entre a faixa etária e o tipo de emprego com a aceitação do depósito a prazo
SELECT job, faixa_etaria,  COUNT(*) AS total_yes
FROM  dados_bancarios
WHERE y = 'yes'
GROUP BY job, faixa_etaria
ORDER BY total_yes DESC;

-- Verificar se a profissão exerce influência na adesão ao depósito a prazo
SELECT job,  COUNT(*) AS total_yes
FROM  dados_bancarios
WHERE y = 'yes'
GROUP BY job
ORDER BY total_yes DESC;

-- Verificar se o nível de educação influencia a adesão ao depósito a prazo
SELECT job, education,  COUNT(*) AS total_yes
FROM  dados_bancarios
WHERE y = 'yes'
GROUP BY job, education
ORDER BY total_yes DESC;

 -- Verificar se o saldo bancário influencia a aceitação do depósito a prazo
select count(*) from  dados_bancarios
where balance < 0 and y= 'yes'; 

-- Verificar se existe diferença na aceitação consoante o canal de contacto: telefone e celular
select contact, COUNT(contact) as total from  dados_bancarios
WHERE y='yes'
group by contact 
order by total DESC;


--  Verificar se o mês em que a campanha foi realizada afecta a aceitação do depósito a prazo
SELECT 
  month, 
  COUNT(contact) AS total_contactos, 
  COUNT(CASE WHEN y = 'yes' THEN 1 END) AS total_sim,
  ROUND(
    100.0 * COUNT(CASE WHEN y = 'yes' THEN 1 END) / COUNT(contact), 
    2
  ) AS percentual_aceitacao
FROM  dados_bancarios 
GROUP BY month 
ORDER BY percentual_aceitacao DESC;

