-- CreateTable
CREATE TABLE `usuarios` (
    `usuario_id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `correo` VARCHAR(191) NOT NULL,
    `contrasena` VARCHAR(191) NOT NULL,
    `fecha_creacion` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `usuarios_correo_key`(`correo`),
    PRIMARY KEY (`usuario_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `categorias` (
    `categoria_id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `descripcion` VARCHAR(191) NULL,

    UNIQUE INDEX `categorias_nombre_key`(`nombre`),
    PRIMARY KEY (`categoria_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tipos_etapa` (
    `tipo_etapa_id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `descripcion` VARCHAR(191) NULL,

    UNIQUE INDEX `tipos_etapa_nombre_key`(`nombre`),
    PRIMARY KEY (`tipo_etapa_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `laboratorios` (
    `laboratorio_id` INTEGER NOT NULL AUTO_INCREMENT,
    `titulo` VARCHAR(191) NOT NULL,
    `descripcion` VARCHAR(191) NULL,
    `categoria_id` INTEGER NOT NULL,
    `tiene_ra` BOOLEAN NOT NULL DEFAULT false,
    `estado` ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
    `fecha_creacion` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `creador_id` INTEGER NOT NULL,

    PRIMARY KEY (`laboratorio_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `etapas_laboratorio` (
    `etapa_id` INTEGER NOT NULL AUTO_INCREMENT,
    `laboratorio_id` INTEGER NOT NULL,
    `tipo_etapa_id` INTEGER NOT NULL,
    `descripcion` VARCHAR(191) NULL,
    `orden` INTEGER NOT NULL DEFAULT 1,

    PRIMARY KEY (`etapa_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `recursos_laboratorio` (
    `recurso_id` INTEGER NOT NULL AUTO_INCREMENT,
    `etapa_id` INTEGER NOT NULL,
    `tipo` ENUM('texto', 'imagen', 'video', 'audio', 'enlace') NOT NULL,
    `titulo` VARCHAR(191) NOT NULL,
    `contenido` VARCHAR(500) NULL,
    `orden` INTEGER NOT NULL DEFAULT 1,

    PRIMARY KEY (`recurso_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `recursos_ra` (
    `ra_id` INTEGER NOT NULL AUTO_INCREMENT,
    `laboratorio_id` INTEGER NOT NULL,
    `url_del_modelo` VARCHAR(500) NOT NULL,
    `url_del_marcador` VARCHAR(500) NULL,
    `descripcion` VARCHAR(191) NULL,

    PRIMARY KEY (`ra_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `laboratorios_grupos` (
    `laboratorio_grupo_id` INTEGER NOT NULL AUTO_INCREMENT,
    `laboratorio_id` INTEGER NOT NULL,
    `nombre_grupo` VARCHAR(191) NOT NULL,
    `codigo_ficha` VARCHAR(191) NULL,
    `link_acceso` VARCHAR(191) NOT NULL,
    `estado` ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
    `fecha_apertura` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `laboratorios_grupos_link_acceso_key`(`link_acceso`),
    PRIMARY KEY (`laboratorio_grupo_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `laboratorios_participantes` (
    `laboratorio_participante_id` INTEGER NOT NULL AUTO_INCREMENT,
    `laboratorio_grupo_id` INTEGER NOT NULL,
    `usuario_id` INTEGER NOT NULL,
    `progreso` ENUM('no iniciado', 'en progreso', 'finalizado') NOT NULL DEFAULT 'no iniciado',
    `fecha_union` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `laboratorios_participantes_usuario_id_laboratorio_grupo_id_key`(`usuario_id`, `laboratorio_grupo_id`),
    PRIMARY KEY (`laboratorio_participante_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cuestionarios` (
    `cuestionario_id` INTEGER NOT NULL AUTO_INCREMENT,
    `laboratorio_id` INTEGER NOT NULL,
    `nombre` VARCHAR(191) NOT NULL,
    `descripcion` VARCHAR(191) NULL,
    `fecha_creacion` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`cuestionario_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `preguntas` (
    `pregunta_id` INTEGER NOT NULL AUTO_INCREMENT,
    `cuestionario_id` INTEGER NOT NULL,
    `tipo` ENUM('1', '2', '3', '4') NOT NULL,
    `enunciado` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`pregunta_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `respuestas` (
    `respuesta_id` INTEGER NOT NULL AUTO_INCREMENT,
    `pregunta_id` INTEGER NOT NULL,
    `enunciado` VARCHAR(191) NOT NULL,
    `correcta` BOOLEAN NOT NULL DEFAULT false,

    PRIMARY KEY (`respuesta_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `respuestas_cuestionario` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `laboratorio_participante_id` INTEGER NOT NULL,
    `respuesta_elegida_id` INTEGER NOT NULL,
    `esCorrecta` BOOLEAN NOT NULL,
    `fecha_respuesta` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `informes_pdf` (
    `informe_id` INTEGER NOT NULL AUTO_INCREMENT,
    `laboratorio_participante_id` INTEGER NOT NULL,
    `intento` INTEGER NOT NULL DEFAULT 1,
    `nombre_archivo` VARCHAR(191) NOT NULL,
    `fecha_generado` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `estado` ENUM('generado', 'pendiente', 'error') NOT NULL DEFAULT 'pendiente',

    UNIQUE INDEX `informes_pdf_laboratorio_participante_id_intento_key`(`laboratorio_participante_id`, `intento`),
    PRIMARY KEY (`informe_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `laboratorios` ADD CONSTRAINT `laboratorios_creador_id_fkey` FOREIGN KEY (`creador_id`) REFERENCES `usuarios`(`usuario_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `laboratorios` ADD CONSTRAINT `laboratorios_categoria_id_fkey` FOREIGN KEY (`categoria_id`) REFERENCES `categorias`(`categoria_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `etapas_laboratorio` ADD CONSTRAINT `etapas_laboratorio_laboratorio_id_fkey` FOREIGN KEY (`laboratorio_id`) REFERENCES `laboratorios`(`laboratorio_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `etapas_laboratorio` ADD CONSTRAINT `etapas_laboratorio_tipo_etapa_id_fkey` FOREIGN KEY (`tipo_etapa_id`) REFERENCES `tipos_etapa`(`tipo_etapa_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `recursos_laboratorio` ADD CONSTRAINT `recursos_laboratorio_etapa_id_fkey` FOREIGN KEY (`etapa_id`) REFERENCES `etapas_laboratorio`(`etapa_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `recursos_ra` ADD CONSTRAINT `recursos_ra_laboratorio_id_fkey` FOREIGN KEY (`laboratorio_id`) REFERENCES `laboratorios`(`laboratorio_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `laboratorios_grupos` ADD CONSTRAINT `laboratorios_grupos_laboratorio_id_fkey` FOREIGN KEY (`laboratorio_id`) REFERENCES `laboratorios`(`laboratorio_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `laboratorios_participantes` ADD CONSTRAINT `laboratorios_participantes_laboratorio_grupo_id_fkey` FOREIGN KEY (`laboratorio_grupo_id`) REFERENCES `laboratorios_grupos`(`laboratorio_grupo_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `laboratorios_participantes` ADD CONSTRAINT `laboratorios_participantes_usuario_id_fkey` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`usuario_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cuestionarios` ADD CONSTRAINT `cuestionarios_laboratorio_id_fkey` FOREIGN KEY (`laboratorio_id`) REFERENCES `laboratorios`(`laboratorio_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `preguntas` ADD CONSTRAINT `preguntas_cuestionario_id_fkey` FOREIGN KEY (`cuestionario_id`) REFERENCES `cuestionarios`(`cuestionario_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respuestas` ADD CONSTRAINT `respuestas_pregunta_id_fkey` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas`(`pregunta_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respuestas_cuestionario` ADD CONSTRAINT `respuestas_cuestionario_laboratorio_participante_id_fkey` FOREIGN KEY (`laboratorio_participante_id`) REFERENCES `laboratorios_participantes`(`laboratorio_participante_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respuestas_cuestionario` ADD CONSTRAINT `respuestas_cuestionario_respuesta_elegida_id_fkey` FOREIGN KEY (`respuesta_elegida_id`) REFERENCES `respuestas`(`respuesta_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `informes_pdf` ADD CONSTRAINT `informes_pdf_laboratorio_participante_id_fkey` FOREIGN KEY (`laboratorio_participante_id`) REFERENCES `laboratorios_participantes`(`laboratorio_participante_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
