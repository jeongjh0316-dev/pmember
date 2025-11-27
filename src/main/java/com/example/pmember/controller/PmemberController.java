package com.example.pmember.controller;

import com.example.pmember.dto.Pmember;
import com.example.pmember.dto.MemberAlergy;
import com.example.pmember.service.PmemberMapper;
import com.example.pmember.service.AlergyMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@Controller
public class PmemberController {

    // 🔹 탈퇴 표시용 특수 비밀번호 값
    private static final String DELETED_PASSWORD_MARKER = "__DELETED__";

    @Autowired
    private PmemberMapper member;

    @Autowired
    private AlergyMapper alergyMapper;

    // 로그인 페이지
    @GetMapping({"/", "/login"})
    public String loginPage() {
        return "login";
    }

    // 홈
    @GetMapping("/home")
    public String home(HttpSession session, Model model) {
        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login != null) {
            model.addAttribute("nickname", login.getId());
        }
        return "home";
    }

    // 비회원
    @GetMapping("/guest")
    public String guestStart(HttpSession session) {
        session.setAttribute("guest", true);
        return "redirect:/home";
    }

    // 아이디 중복 체크 (탈퇴 계정도 "exist" 처리 → 아이디 재사용 금지)
    @GetMapping("/check-id")
    @ResponseBody
    public String checkId(@RequestParam String id) {
        int count = member.countById(id);
        return (count > 0) ? "exist" : "ok";
    }

    // ============================
    // 회원가입
    // ============================
    @PostMapping("/join")
    public String join(
            @RequestParam String id,
            @RequestParam String pw,
            @RequestParam String pw2,
            @RequestParam String email,
            @RequestParam(required = false) String birthYear,
            @RequestParam(required = false) String birthMonth,
            @RequestParam(required = false) String birthDay,
            @RequestParam(required = false) String[] gender,
            Model model
    ) {
        // 1) 비밀번호 불일치
        if (!pw.equals(pw2)) {
            model.addAttribute("joinError", "비밀번호가 일치하지 않습니다.");
            model.addAttribute("activeTab", "join");
            return "login";
        }

        // 공통으로 쓸 생년월일 / 성별 문자열 구성
        String birth = null;
        if (birthYear != null && birthMonth != null && birthDay != null) {
            birth = String.format("%s-%02d-%02d",
                    birthYear,
                    Integer.parseInt(birthMonth),
                    Integer.parseInt(birthDay));
        }

        String genderStr = (gender != null && gender.length > 0)
                ? String.join(",", gender)
                : "private";

        // 2) 아이디로 기존 회원 조회
        Pmember existing = member.findById(id);

        // ============================
        // 2-1) 기존에 같은 id가 있음
        // ============================
        if (existing != null) {

            // (1) 탈퇴 상태가 아닌 계정 → 그냥 사용 중인 아이디이므로 가입 불가
            if (!DELETED_PASSWORD_MARKER.equals(existing.getPw())) {
                model.addAttribute("joinError", "이미 사용 중인 아이디입니다.");
                model.addAttribute("activeTab", "join");
                return "login";
            }

            // (2) 탈퇴한 계정인데, 이메일이 다르면 → 다른 사람이 쓰던 아이디로 판단, 재사용 금지
            if (!existing.getEmail().equals(email)) {
                model.addAttribute("joinError", "예전에 사용된 아이디입니다. 다른 아이디를 사용해주세요.");
                model.addAttribute("activeTab", "join");
                return "login";
            }

            // (3) 탈퇴한 계정 + 같은 이메일 → "돌아온 회원"으로 보고 기존 행 UPDATE
            existing.setPw(pw);
            existing.setBirth(birth);
            existing.setGender(genderStr);
            existing.setEmail(email); // 원래 같지만, 혹시 몰라 한 번 더 세팅

            int cnt = member.updateMemberWithPw(id, existing); // oldId = id
            if (cnt <= 0) {
                model.addAttribute("joinError", "회원가입에 실패했습니다.");
                model.addAttribute("activeTab", "join");
                return "login";
            }

            model.addAttribute("showJoinSuccessModal", true);
            return "login";
        }

        // ============================
        // 2-2) 완전 신규 id인 경우
        // ============================

        // 이메일 중복 체크 (탈퇴 계정의 이메일도 포함해서 중복으로 봄)
        if (member.existsByEmail(email) > 0) {
            model.addAttribute("joinError", "이미 가입된 이메일입니다.");
            model.addAttribute("activeTab", "join");
            return "login";
        }

        // 신규 회원 INSERT
        Pmember m = new Pmember();
        m.setId(id);
        m.setPw(pw);
        m.setEmail(email);
        m.setBirth(birth);
        m.setGender(genderStr);

        int cnt = member.insert(m);
        if (cnt <= 0) {
            model.addAttribute("joinError", "회원가입에 실패했습니다.");
            model.addAttribute("activeTab", "join");
            return "login";
        }

        model.addAttribute("showJoinSuccessModal", true);
        return "login";
    }

    // ============================
    // 로그인
    // ============================
    @PostMapping("/login")
    public String doLogin(
            @RequestParam String id,
            @RequestParam String pw,
            HttpSession session,
            Model model
    ) {
        Pmember db = member.findById(id);
        if (db == null) {
            model.addAttribute("loginError", "존재하지 않는 아이디입니다.");
            model.addAttribute("activeTab", "login");
            return "login";
        }

        // 🔹 탈퇴 처리된 계정이면 로그인 불가
        if (DELETED_PASSWORD_MARKER.equals(db.getPw())) {
            model.addAttribute("loginError", "탈퇴한 계정입니다. 같은 아이디와 이메일로 다시 가입해주세요.");
            model.addAttribute("activeTab", "login");
            return "login";
        }

        if (!pw.equals(db.getPw())) {
            model.addAttribute("loginError", "비밀번호가 올바르지 않습니다.");
            model.addAttribute("activeTab", "login");
            return "login";
        }

        session.setAttribute("loginMember", db);
        session.removeAttribute("guest");
        return "redirect:/home";
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    // ============================
    // ⭐ 회원 탈퇴 (논리 삭제)
    // ============================
    @PostMapping("/member/delete")
    public String deleteMember(HttpSession session) {
        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login != null) {
            // 비밀번호를 특수값으로 변경해서 "탈퇴 상태" 표시
            member.updatePassword(login.getId(), DELETED_PASSWORD_MARKER);
            session.invalidate();
        }
        return "redirect:/login";
    }

    // ============================================
    // ⭐ 아이디 찾기: 틀리면 login.jsp + 토스트, 맞으면 findid.jsp
    // ============================================
    @PostMapping("/find-id")
    public String findId(
            @RequestParam String email,
            @RequestParam String birthYear,
            @RequestParam String birthMonth,
            @RequestParam String birthDay,
            Model model
    ) {
        String birth = String.format("%s-%02d-%02d",
                birthYear,
                Integer.parseInt(birthMonth),
                Integer.parseInt(birthDay));

        // 1) 이메일 존재 여부
        if (member.existsByEmail(email) == 0) {
            model.addAttribute("activeTab", "find");
            model.addAttribute("toastMessage", "가입되지 않은 이메일입니다.");
            return "login";
        }

        // 2) 이메일은 있는데 생년월일 불일치인 경우
        String foundId = member.findIdByEmailAndBirth(email, birth);
        if (foundId == null) {
            model.addAttribute("activeTab", "find");
            model.addAttribute("toastMessage", "생년월일이 일치하지 않습니다.");
            return "login";
        }

        // 3) 정상 조회 → 결과 페이지로 이동
        model.addAttribute("foundId", foundId);
        return "findid"; // findid.jsp
    }

    // 검색 페이지 이동용 GET (직접 URL 접근 시)
    @GetMapping("/findid")
    public String goFindIdPage() {
        return "findid";
    }

    // ============================================
    // ⭐ 비밀번호 찾기: 틀리면 login.jsp + 토스트, 맞으면 findpw.jsp
    // ============================================
    @PostMapping("/find-pw")
    public String findPw(
            @RequestParam String id,
            @RequestParam String email,
            Model model
    ) {
        Pmember db = member.findById(id);

        // 1) 아이디 없음
        if (db == null) {
            model.addAttribute("activeTab", "find");
            model.addAttribute("toastMessage", "존재하지 않는 아이디입니다.");
            return "login";
        }

        // 2) 탈퇴 계정이면 비번 재발급 대신 재가입 유도
        if (DELETED_PASSWORD_MARKER.equals(db.getPw())) {
            model.addAttribute("activeTab", "find");
            model.addAttribute("toastMessage", "탈퇴한 계정입니다. 같은 아이디와 이메일로 다시 가입해주세요.");
            return "login";
        }

        // 3) 이메일 불일치
        if (!db.getEmail().equals(email)) {
            model.addAttribute("activeTab", "find");
            model.addAttribute("toastMessage", "이메일이 일치하지 않습니다.");
            return "login";
        }

        // 4) 정상 → 임시 비밀번호 생성 및 DB 업데이트 후 결과 페이지
        String tempPw = UUID.randomUUID().toString().substring(0, 8);
        member.updatePassword(id, tempPw);

        model.addAttribute("tempPw", tempPw);
        return "findpw"; // findpw.jsp
    }

    // 페이지 이동 GET
    @GetMapping("/findpw")
    public String goFindPwPage() {
        return "findpw";
    }

    // ============================================
    // ⭐ 기존 알레르기 저장 기능 그대로
    // ============================================
    @PostMapping("/mypage/allergy")
    public String saveUserAlergy(
            @RequestParam(value = "alergyIds", required = false) List<Integer> alergyIds,
            HttpSession session
    ) {
        Pmember login = (Pmember) session.getAttribute("loginMember");
        if (login == null) {
            return "redirect:/login";
        }

        String id = login.getId();

        alergyMapper.deleteUserAlergyById(id);

        if (alergyIds != null && !alergyIds.isEmpty()) {
            for (Integer alIdx : alergyIds) {
                MemberAlergy ma = new MemberAlergy();
                ma.setId(id);
                ma.setAl_idx(alIdx);
                alergyMapper.insertUserAlergy(ma);
            }
        }

        return "redirect:/mypage?tab=settings";
    }
}
