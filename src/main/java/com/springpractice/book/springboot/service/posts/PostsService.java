package com.springpractice.book.springboot.service.posts;

import com.springpractice.book.springboot.domain.posts.Posts;
import com.springpractice.book.springboot.domain.posts.PostsRepository;
import com.springpractice.book.springboot.web.dto.PostsResponseDto;
import com.springpractice.book.springboot.web.dto.PostsSaveRequestDto;
import com.springpractice.book.springboot.web.dto.PostsUpdateRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class PostsService {
    private  final PostsRepository postsRepository;

    @Transactional
    public Long save(PostsSaveRequestDto requestDto) {
        return postsRepository.save(requestDto.toEntity()).getId();
    }

    @Transactional
    public Long update(Long id, PostsUpdateRequestDto requestDto) {
        Posts posts = postsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("There is no posts with given id=" + id));

        posts.update(requestDto.getTitle(), requestDto.getContent());

        return id;
    }

    public PostsResponseDto findById(Long id) {
        Posts posts = postsRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("There is no posts with given id=" + id));

        return new PostsResponseDto(posts);
    }

    public List<PostsResponseDto> findAll() {
        List<Posts> all = postsRepository.findAll();
        return all.stream().map(posts -> new PostsResponseDto(posts)).collect(Collectors.toList());
    }
}
