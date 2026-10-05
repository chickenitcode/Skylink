import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global prefix
  app.setGlobalPrefix('api/v1');

  // Validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // CORS
  app.enableCors({
    origin: '*', // Restrict in production
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
  });

  // Swagger
  const config = new DocumentBuilder()
    .setTitle('GASCOLAE Service Intelligence API')
    .setDescription(
      'Internal MVP API for Service Intelligence — consultation, knowledge retrieval, service matching, and proposal generation.',
    )
    .setVersion('0.1.0')
    .addBearerAuth()
    .addTag('auth', 'Authentication & Session Management')
    .addTag('services', 'Service Catalog & Knowledge')
    .addTag('knowledge', 'Knowledge Search & Retrieval')
    .addTag('consultations', 'Consultation Workflow')
    .addTag('matching', 'Service Matching')
    .addTag('proposals', 'Proposal Pipeline')
    .addTag('reviews', 'Proposal Review & Approval')
    .addTag('documents', 'Document Generation')
    .addTag('admin', 'Administration')
    .addTag('health', 'Health Check')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`🚀 GASCOLAE Service Intelligence API running on port ${port}`);
  console.log(`📚 Swagger: http://localhost:${port}/api/docs`);
}
bootstrap();
