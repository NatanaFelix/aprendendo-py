/*select de sobras oficial!!!!!*/
-- SELECT UF, year(data), categoria, sum(sobras_nf) as total_sobras FROM (
	SELECT 
    recupera2023.input.id AS 'ID',
    CASE
        WHEN
            JSON_UNQUOTE(JSON_EXTRACT(json,
                            '$.nfeProc.NFe.infNFe.det.prod.xProd')) IS NOT NULL
        THEN
            JSON_EXTRACT(json,
                    '$.nfeProc.NFe.infNFe.det.prod.xProd')
        WHEN
            JSON_UNQUOTE(JSON_EXTRACT(json,
                            '$.nfeProc.NFe.infNFe.det[*].prod.xProd')) IS NOT NULL
        THEN
            JSON_EXTRACT(json,
                    '$.nfeProc.NFe.infNFe.det[*].prod.xProd')
        WHEN JSON_UNQUOTE(JSON_EXTRACT(json, '$.NFe.infNFe.det.prod.xProd')) IS NOT NULL THEN JSON_EXTRACT(json, '$.NFe.infNFe.det.prod.xProd')
        WHEN JSON_UNQUOTE(JSON_EXTRACT(json, '$.NFe.infNFe.det[*].prod.xProd')) IS NOT NULL THEN JSON_EXTRACT(json, '$.NFe.infNFe.det[*].prod.xProd')
        ELSE NULL
    END AS xProd,
    recupera2023.material.name AS material,
    recupera2023.category.name AS 'Categoria',
    recupera2023.input.amount AS total_item_nf,
    SUM(IFNULL(recupera2023.goal_input.amount, 0)) AS 'Total Usado da NF',
    (recupera2023.input.amount - IFNULL(SUM(recupera2023.goal_input.amount), 0)) AS sobras_nf,
    CASE
        WHEN
            JSON_UNQUOTE(JSON_EXTRACT(json,
                            '$.nfeProc.NFe.infNFe.det.prod.NCM')) IS NOT NULL
        THEN
            JSON_EXTRACT(json,
                    '$.nfeProc.NFe.infNFe.det.prod.NCM')
        WHEN
            JSON_UNQUOTE(JSON_EXTRACT(json,
                            '$.nfeProc.NFe.infNFe.det[*].prod.NCM')) IS NOT NULL
        THEN
            JSON_EXTRACT(json,
                    '$.nfeProc.NFe.infNFe.det[*].prod.NCM')
        WHEN JSON_UNQUOTE(JSON_EXTRACT(json, '$.NFe.infNFe.det.prod.NCM')) IS NOT NULL THEN JSON_EXTRACT(json, '$.NFe.infNFe.det.prod.NCM')
        WHEN JSON_UNQUOTE(JSON_EXTRACT(json, '$.NFe.infNFe.det[*].prod.NCM')) IS NOT NULL THEN JSON_EXTRACT(json, '$.NFe.infNFe.det[*].prod.NCM')
        ELSE NULL
    END AS NCM,
    CASE
        WHEN
            JSON_UNQUOTE(JSON_EXTRACT(json,
                            '$.nfeProc.NFe.infNFe.det.prod.CFOP')) IS NOT NULL
        THEN
            JSON_EXTRACT(json,
                    '$.nfeProc.NFe.infNFe.det.prod.CFOP')
        WHEN
            JSON_UNQUOTE(JSON_EXTRACT(json,
                            '$.nfeProc.NFe.infNFe.det[*].prod.CFOP')) IS NOT NULL
        THEN
            JSON_EXTRACT(json,
                    '$.nfeProc.NFe.infNFe.det[*].prod.CFOP')
        WHEN JSON_UNQUOTE(JSON_EXTRACT(json, '$.NFe.infNFe.det.prod.CFOP')) IS NOT NULL THEN JSON_EXTRACT(json, '$.NFe.infNFe.det.prod.CFOP')
        WHEN JSON_UNQUOTE(JSON_EXTRACT(json, '$.NFe.infNFe.det[*].prod.CFOP')) IS NOT NULL THEN JSON_EXTRACT(json, '$.NFe.infNFe.det[*].prod.CFOP')
        ELSE NULL
    END AS CFOP,
    recupera2023.invoice.invoice_id AS 'NF',
    recupera2023.invoice.invoice_number AS 'Número NF',
    DATE(recupera2023.input.date) AS data,
    recupera2023.organization.name AS organizacao,
    recupera2023.organization.national_id AS cnpj_organizacao,
    JSON_UNQUOTE(JSON_EXTRACT(address, '$.state')) AS uf
FROM
    recupera2023.input
        LEFT JOIN
    recupera2023.goal_input ON recupera2023.input.id = recupera2023.goal_input.input
        LEFT JOIN
    recupera2023.goal ON recupera2023.goal.id = recupera2023.goal_input.goal
        LEFT JOIN
    recupera2023.invoice ON recupera2023.invoice.id = recupera2023.input.invoice
        LEFT JOIN
    recupera2023.material ON recupera2023.material.id = recupera2023.input.material
        LEFT JOIN
    recupera2023.category ON recupera2023.category.id = recupera2023.material.category
        LEFT JOIN
    recupera2023.organization ON recupera2023.organization.id = recupera2023.input.organization
WHERE
    (JSON_UNQUOTE(JSON_EXTRACT(address, '$.state')) = 'SP'
        OR JSON_UNQUOTE(JSON_EXTRACT(address, '$.state')) = 'GO'
        OR JSON_UNQUOTE(JSON_EXTRACT(address, '$.state')) = 'RJ')
        AND YEAR(recupera2023.input.date) IN (2023 , 2024)
GROUP BY id 
/*) AS SOBRAS
where sobras_nf > 0
GROUP BY UF, year(data), categoria*/