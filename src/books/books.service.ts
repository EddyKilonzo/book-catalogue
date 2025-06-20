import { Injectable, NotFoundException, InternalServerErrorException, ConflictException } from '@nestjs/common';
import { book } from './interfaces/books.interface';
import { CreateBookDto } from './Dto/create.book.dto';
import { UpdateBookDto } from './Dto/update.books.dto';
import { DatabaseService } from 'src/database/connection.services';

@Injectable()
export class BooksService {
  constructor(private readonly databaseService: DatabaseService) {}

  async create(createBookDto: CreateBookDto): Promise<book> {
    try {
      const result = await this.databaseService.query('SELECT * FROM sp_create_book($1::varchar, $2::varchar, $3::integer, $4::varchar)', [
        createBookDto.title,
        createBookDto.author,
        createBookDto.publication_year,
        createBookDto.isbn
      ]);
      if(result.rows.length === 0){
        throw new NotFoundException('Book not found');
      }
      return result.rows[0];
      
      
    } catch (error) {
      if (error.message.includes('already exists')) {
        throw new ConflictException(`Book with ISBN ${createBookDto.isbn} already exists`);
      }
      console.error('Database error:', error);
      throw new InternalServerErrorException('Failed to create book');
    }
  }

  async findAllBooks(): Promise<book[]> {
    try {
      const result = await this.databaseService.query(
        `SELECT * FROM sp_get_books()`
      );
      if (result.rows.length === 0) {
        throw new NotFoundException('No books found');
      }
      return result.rows;
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      console.error('Database error:', error);
      throw new InternalServerErrorException('Failed to retrieve books');
    }
  }
  async findByauthor(author: string): Promise<book[]> {
    const query = `SELECT * FROM sp_get_books_by_author($1)`;
    const result = await this.databaseService.query(query, [author]);
    return result.rows;
  }

  async findBytitle(title: string): Promise<book[]> {
    const query = `SELECT * FROM sp_get_books_by_title($1)`;
    const result = await this.databaseService.query(query, [title]);
    return result.rows;
  }

  async findByisbn(isbn: string): Promise<book[]> {
    const query = `SELECT * FROM sp_get_books_by_isbn($1)`;
    const result = await this.databaseService.query(query, [isbn]);
    return result.rows;
  }

  async deleteBook(id: number): Promise<book> {
    try {
      const result = await this.databaseService.query(
        `SELECT * FROM sp_delete_book($1::integer)`,
        [id]
      );
      if (result.rows.length === 0) {
        throw new NotFoundException(`Book with ID ${id} not found`);
      }
      return result.rows[0];
    }
    catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      console.error('Database error:', error);
      throw new InternalServerErrorException(`Failed to delete book ${id}`);
    }
  }

  async findOneBook(id: number): Promise<book> {
    try {
      const result = await this.databaseService.query(
        `SELECT * FROM sp_get_books($1::integer)`,
        [id]
      );
      if (result.rows.length === 0) {
        throw new NotFoundException(`Book with ID ${id} not found`);
      }
      return result.rows[0];
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      console.error('Database error:', error);
      throw new InternalServerErrorException(`Failed to retrieve book ${id}`);
    }
  }

  // ...

  async updateBook(id: number, data: UpdateBookDto): Promise<book> {
    try {
      const result = await this.databaseService.query(
        `SELECT * FROM sp_update_book($1::integer, $2::varchar, $3::varchar, $4::integer, $5::varchar)`,
        [
          id,
          data.title,
          data.author,
          data.publication_year,
          data.isbn
        ]
      );

      if (result.rows.length === 0) {
        throw new NotFoundException(`Book with ID ${id} not found`);
      }
      return result.rows[0];
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      console.error('Database error:', error);
      throw new InternalServerErrorException(`Failed to update book ${id}`);
    }
  }
}
