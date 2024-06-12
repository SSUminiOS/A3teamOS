# 운영체제 miniOS 프로젝트

## 참여 인원
|허성현|김도형|윤재선|권정태|
|:------:|:------:|:------:|:------:|
| <img width="160px" src="https://avatars.githubusercontent.com/u/89961315?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/58456758?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/58286830?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/102507306?v=4"/> |
|[hershey95](https://github.com/hershey95)|[pdohyung](https://github.com/pdohyung)|[se0nShine](https://github.com/se0nShine)|[oxdjww](https://github.com/oxdjww)|
</br>

## 실행 방법
### linux 환경에서 test 실행 방법
1. 터미널에서 다음 명령어를 실행합니다.
    
    ```bash
    git clone https://github.com/SSUminiOS/A3teamOS/tree/main 
    ```
    
2. 터미널에서 makefile이 있는 디렉토리인 src에 접근을 합니다.
    
    ```bash
    cd src
    ```
    
3. 터미널에서 명령어로 make qemu-nox를 입력합니다.
    
    ```bash
    make qemu-nox
    ```
    
4. xv6를 실행 후 slabtest를 입력하여 출력 결과를 확인합니다.
    
    ```bash
    slabtest
    ```
### docker 환경에서 test 실행 방법
![Untitled](https://github.com/SSUminiOS/A3teamOS/assets/58456758/1d25a4a0-dbdf-443c-9f9c-a8fae038f450)

<img width="1077" alt="Untitled" src="https://github.com/SSUminiOS/A3teamOS/assets/58456758/33cd178d-7c19-4a2c-809b-d38d86ce81ef">

1. git clone 이후, vscode에서 docker-compose 파일을 실행 `docker compose up -d` 그리고 vscode 좌하단에 `><`를 클릭하여 실행 중인 컨테이너에 연결을 누르고 xv6 컨테이너에 연결

<img width="915" alt="Untitled" src="https://github.com/SSUminiOS/A3teamOS/assets/58456758/5bf052e0-baa1-4a21-b39e-fed32ef2e43d">

2. xv6 컨테이너에 접속하고 vscode 파일 열기를 통해 `/home/ubuntu/src`경로에 접속

<img width="779" alt="Untitled" src="https://github.com/SSUminiOS/A3teamOS/assets/58456758/45008e17-f99e-4300-ac30-b949fcf03a97">

3. `apt-update` 명령어 실행

<img width="1112" alt="Untitled" src="https://github.com/SSUminiOS/A3teamOS/assets/58456758/cb95a816-6a7a-4517-aa36-905e8b9f4fda">

4. `apt-get install -y build-essential qemu gcc-multilib qemu-system-x86` 명령어 실행

<img width="860" alt="Untitled" src="https://github.com/SSUminiOS/A3teamOS/assets/58456758/db74bd28-a1ee-4e19-ab2c-cce8893f815c">

<img width="860" alt="Untitled" src="https://github.com/SSUminiOS/A3teamOS/assets/58456758/037fbbca-c29e-4830-bdf7-2c239dff07aa">

5. `make qemu-nox로 build`하고 `slabtest` 실행 시 테스트 결과 확인 가능

### 만약 make qemu-nox에서 `make: *** No rule to make target gnu/9/include/stdbool.h', needed by 'slab.o'.  Stop.` 오류가 발생한 경우

<img width="842" alt="Untitled" src="https://github.com/SSUminiOS/A3teamOS/assets/58456758/b1eb9da9-e018-425a-9e5b-60faec92894c">

`apt install build-essential` 명령어 실행