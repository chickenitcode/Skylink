import { Injectable } from '@nestjs/common';

export interface LlmProvider {
  extractRequirements(text: string): Promise<any>;
  matchService(requirements: any, candidateChunks: any[]): Promise<any>;
  generateProposal(requirements: any, service: any, chunks: any[]): Promise<any>;
}

export interface EmbeddingProvider {
  generateEmbeddings(texts: string[]): Promise<number[][]>;
}

@Injectable()
export class AiService {
  // Service wrapper logic that uses either MockProvider or GeminiProvider based on ENV
}
