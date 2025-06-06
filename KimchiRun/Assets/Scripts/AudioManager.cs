using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager instance;

    [Header("BGM")]
    public AudioClip bgmClip;
    public float bgmVolume = 1f;
    private AudioSource bgmPlayer;
    private AudioHighPassFilter bgmFilter;

    [Header("SFX")]
    public AudioClip[] sfxClips;
    public float sfxVolume = 1f;
    public int channels;
    private AudioSource[] sfxPlayers;
    private int channelIndex;

    public enum Sfx
    {
        Start, Jump, Land, Hit, Heal, Gold
    }

    void Awake()
    {
        instance = this;
        Init();
    }

    void Init()
    {
        GameObject bgmObject = new GameObject("BGM Player");
        bgmObject.transform.parent = transform;
        bgmPlayer = bgmObject.AddComponent<AudioSource>();
        bgmPlayer.clip = bgmClip;
        bgmPlayer.volume = bgmVolume;
        bgmPlayer.playOnAwake = false;
        bgmPlayer.loop = true;
        bgmFilter = Camera.main.GetComponent<AudioHighPassFilter>();

        GameObject sfxObject = new GameObject("SFX Player");
        sfxObject.transform.parent = transform;
        sfxPlayers = new AudioSource[channels];
        for (int i = 0; i < channels; i++)
        {
            sfxPlayers[i] = sfxObject.AddComponent<AudioSource>();
            sfxPlayers[i].volume = sfxVolume;
            sfxPlayers[i].playOnAwake = false;
            sfxPlayers[i].bypassEffects = true;
        }
    }

    public void PlayBgm(bool isPlay)
    {
        if (isPlay)
            bgmPlayer.Play();
        else
            bgmPlayer.Stop();
    }

    public void FilterBgm(bool isPlay)
    {
        bgmFilter.enabled = isPlay;
    }

    public void PlaySfx(Sfx sfx)
    {
        for (int i = 0; i < sfxPlayers.Length; i++)
        {
            int loopIndex = (i + channelIndex) % sfxPlayers.Length;
            if (sfxPlayers[loopIndex].isPlaying) continue;
            channelIndex = loopIndex;
            sfxPlayers[loopIndex].clip = sfxClips[(int)sfx];
            sfxPlayers[loopIndex].Play();
            break;
        }
    }
}
