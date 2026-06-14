INSERT INTO categories (name, description) VALUES
    ("Copos Descartáveis", "Copos de plástico e papel para diversas bebidas."),
    ("Embalagens para Alimentos", "Embalagens para transporte e armazenamento de alimentos."),
    ("Talheres Descartáveis", "Talheres de plástico e biodegradáveis."),
    ("Pratos Descartáveis", "Pratos de plástico e papel para refeições."),
    ("Guardanapos e Toalhas", "Guardanapos de papel e toalhas descartáveis.");

INSERT INTO products (name, description, price, category_id, image_url, tags) VALUES
    ("Copo Plástico Transparente 200ml", "Ideal para água e refrigerante. Pacote com 100 unidades.", 12.50, 1, "https://example.com/copo200ml.jpg", "copo, plástico, transparente, 200ml, água, refrigerante"),
    ("Copo de Papel Biodegradável 300ml", "Para bebidas quentes e frias. Pacote com 50 unidades.", 25.00, 1, "https://example.com/copopapel300ml.jpg", "copo, papel, biodegradável, 300ml, quente, frio"),
    ("Embalagem Retangular com Tampa 750ml", "Para refeições e delivery. Pacote com 20 unidades.", 35.00, 2, "https://example.com/embalagem750ml.jpg", "embalagem, retangular, tampa, refeição, delivery"),
    ("Talher Garfo Plástico Branco", "Garfo descartável resistente. Pacote com 100 unidades.", 10.00, 3, "https://example.com/garfo.jpg", "talher, garfo, plástico, branco"),
    ("Prato Fundo de Papel 18cm", "Para sopas e caldos. Pacote com 50 unidades.", 18.00, 4, "https://example.com/pratofundo.jpg", "prato, fundo, papel, 18cm, sopa, caldo"),
    ("Guardanapo de Papel Folha Dupla", "Alta absorção. Pacote com 200 unidades.", 8.50, 5, "https://example.com/guardanapo.jpg", "guardanapo, papel, folha dupla, absorção"),
    ("Copo Térmico de Isopor 180ml", "Mantém a temperatura. Pacote com 50 unidades.", 15.00, 1, "https://example.com/copoisopor.jpg", "copo, térmico, isopor, 180ml, café"),
    ("Embalagem para Bolo Redonda Pequena", "Com base e tampa transparente. Pacote com 10 unidades.", 28.00, 2, "https://example.com/embalagembolo.jpg", "embalagem, bolo, redonda, pequena, doce"),
    ("Faca Plástica Descartável", "Faca resistente para diversos alimentos. Pacote com 100 unidades.", 11.00, 3, "https://example.com/faca.jpg", "talher, faca, plástico"),
    ("Prato Raso de Plástico 23cm", "Para pratos principais. Pacote com 50 unidades.", 22.00, 4, "https://example.com/pratoraso.jpg", "prato, raso, plástico, 23cm, refeição");
