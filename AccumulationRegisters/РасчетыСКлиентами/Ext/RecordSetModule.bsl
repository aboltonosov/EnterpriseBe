﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Ниже приведеный код, должен выполняться до проверки:
	// Если ОбменДанными.Загрузка Тогда
	//	Возврат
	// КонецЕсли;
	// т.к. существет проверка на доп. свойство ДляПроведения, и 
	// данный объект в РИБ при записи должен создавать запись р/с Задания к перерасчету взаиморасчетов.
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Регистратор  КАК Регистратор,
	|	Таблица.ЗаказКлиента КАК ЗаказКлиента,
	|	Таблица.Валюта       КАК Валюта,
	|	ВЫБОР КОГДА НЕ Таблица.ИсключатьПриКонтроле ТОГДА
	|			ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|					-Таблица.КОплате
	|				ИНАЧЕ Таблица.КОплате
	|			КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ                КАК КОплатеПередЗаписью,
	|	ВЫБОР КОГДА НЕ Таблица.ИсключатьПриКонтроле ТОГДА
	|			ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|					Таблица.Оплачивается
	|				ИНАЧЕ - Таблица.Оплачивается
	|			КОНЕЦ
	|	КОНЕЦ                КАК ОплачиваетсяПередЗаписью,
	|	0                    КАК КОплатеПередЗаписьюКонтрольСрока,
	|	0                    КАК ОплачиваетсяПередЗаписьюКонтрольСрока,
	|	0                    КАК СуммаПередЗаписью,
	|	0                    КАК ОтгружаетсяПередЗаписью,
	|	0                    КАК ДопустимаяСуммаЗадолженностиПередЗаписью
	|
	|ПОМЕСТИТЬ РасчетыСКлиентамиПередЗаписью
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И (Таблица.ЗаказКлиента ССЫЛКА Документ.ЗаказКлиента
	|		ИЛИ Таблица.ЗаказКлиента ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|		ИЛИ Таблица.ЗаказКлиента ССЫЛКА Документ.РеализацияТоваровУслуг)
	|	И (Таблица.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
	|		И Таблица.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка))
	|	И НЕ &ЭтоНовый
	|	И НЕ &ОбменДанными
	|	И &РассчитыватьИзменения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.Регистратор                  КАК Регистратор,
	|	Таблица.ЗаказКлиента                 КАК ЗаказКлиента,
	|	Таблица.Валюта                       КАК Валюта,
	|	0                                    КАК КОплатеПередЗаписью,
	|	0                                    КАК ОплачиваетсяПередЗаписью,
	|	ВЫБОР КОГДА Таблица.Период <= &ПериодКонтроляСрокаДолга ТОГДА
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|				-Таблица.КОплате
	|			ИНАЧЕ Таблица.КОплате
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ                                КАК КОплатеПередЗаписьюКонтрольСрока,
	|	ВЫБОР КОГДА Таблица.Период <= &ПериодКонтроляСрокаДолга ТОГДА
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|				Таблица.Оплачивается
	|			ИНАЧЕ -Таблица.Оплачивается
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ                                КАК ОплачиваетсяПередЗаписьюКонтрольСрока,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			ВЫБОР КОГДА Таблица.Сумма < 0 ТОГДА
	|					0
	|				ИНАЧЕ -Таблица.Сумма
	|			КОНЕЦ
	|		ИНАЧЕ Таблица.Сумма
	|	КОНЕЦ                                КАК СуммаПередЗаписью,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			0
	|		ИНАЧЕ Таблица.Отгружается
	|	КОНЕЦ                                КАК ОтгружаетсяПередЗаписью,
	|	Таблица.ДопустимаяСуммаЗадолженности КАК ДопустимаяСуммаЗадолженностиПередЗаписью
	|
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|	И Таблица.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
	|	И НЕ &ОбменДанными
	|	И &РассчитыватьИзменения
	|;
	|/////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расчеты.ВидДвижения               КАК ВидДвижения,
	|	Расчеты.Регистратор               КАК Регистратор,
	|	Расчеты.Период                    КАК Период,
	|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказКлиента              КАК ЗаказКлиента,
	|	Расчеты.Валюта                    КАК Валюта,
	|
	|	Расчеты.Сумма        КАК Сумма,
	|	Расчеты.Оплачивается КАК Оплачивается,
	|	Расчеты.Отгружается  КАК Отгружается,
	|
	|	Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Расчеты.СуммаРегл                     КАК СуммаРегл,
	|	Расчеты.СуммаУпр                      КАК СуммаУпр,
	|	Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ПОМЕСТИТЬ РасчетыСКлиентамиИсходныеДвижения
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|ГДЕ
	|	Расчеты.Регистратор = &Регистратор
	|	И Расчеты.Сумма <> 0
	|");
	
	Запрос.УстановитьПараметр("Регистратор",              Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ПериодКонтроляСрокаДолга", Макс(КонецДня(ТекущаяДатаСеанса()), КонецДня(ДополнительныеСвойства.ДатаРегистратора)));
	Запрос.УстановитьПараметр("ЭтоНовый",                 ?(ДополнительныеСвойства.Свойство("ЭтоНовый"), ДополнительныеСвойства.ЭтоНовый, Ложь));
	Запрос.УстановитьПараметр("ОбменДанными",              ОбменДанными.Загрузка);
	Запрос.УстановитьПараметр("РассчитыватьИзменения",     ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства));
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СФормироватьТаблицуОбъектовОплаты();
	РегистрыСведений.ГрафикПлатежей.УстановитьБлокировкиДанныхДляРасчетаГрафика(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты, "РегистрНакопления.РасчетыСКлиентами", "ЗаказКлиента");
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка:
	// Если ОбменДанными.Загрузка Тогда
	//	Возврат
	// КонецЕсли;
	// Не требуется, т.к. существет проверка на доп. свойство ДляПроведения,
	// а данный объект в РИБ при записи должен создавать запись р/с Задания к перерасчету взаиморасчетов.
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаИзменений.ЗаказКлиента КАК ЗаказКлиента,
	|	ТаблицаИзменений.Валюта       КАК Валюта,
	|	СУММА(ТаблицаИзменений.КОплатеИзменение) КАК КОплатеИзменение
	|	
	|ПОМЕСТИТЬ ДвиженияРасчетыСКлиентамиИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.ЗаказКлиента               КАК ЗаказКлиента,
	|		Таблица.Валюта                     КАК Валюта,
	|		Таблица.КОплатеПередЗаписью        КАК КОплатеИзменение,
	|		Таблица.ОплачиваетсяПередЗаписью   КАК ОплачиваетсяИзменение
	|	ИЗ
	|		РасчетыСКлиентамиПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.ЗаказКлиента КАК ЗаказКлиента,
	|		Таблица.Валюта       КАК Валюта,
	|		ВЫБОР КОГДА Не Таблица.ИсключатьПриКонтроле ТОГДА
	|				ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|						Таблица.КОплате
	|					ИНАЧЕ -Таблица.КОплате
	|				КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР КОГДА Не Таблица.ИсключатьПриКонтроле ТОГДА
	|				ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|						-Таблица.Оплачивается
	|					ИНАЧЕ Таблица.Оплачивается
	|				КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентами КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор

	|		И (Таблица.ЗаказКлиента ССЫЛКА Документ.ЗаказКлиента
	|			ИЛИ Таблица.ЗаказКлиента ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|			ИЛИ Таблица.ЗаказКлиента ССЫЛКА Документ.РеализацияТоваровУслуг
	//++ НЕ УТКА
	|			ИЛИ Таблица.ЗаказКлиента ССЫЛКА Документ.ЗаказДавальца
	//-- НЕ УТКА
	|			)
	|		И (Таблица.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
	|			И Таблица.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
	//++ НЕ УТКА
	|			И Таблица.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказДавальца.ПустаяСсылка)
	//-- НЕ УТКА
	|			)
	|
	|) КАК ТаблицаИзменений
	|ГДЕ
	|	НЕ &ОбменДанными
	|	И &РассчитыватьИзменения
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.ЗаказКлиента,
	|	ТаблицаИзменений.Валюта
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КОплатеИзменение) + СУММА(ТаблицаИзменений.ОплачиваетсяИзменение) < 0
	|;
	|////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаИзменений.Регистратор                                  КАК Регистратор,
	|	ТаблицаИзменений.ЗаказКлиента                                 КАК ЗаказКлиента,
	|	ТаблицаИзменений.Валюта                                       КАК Валюта,
	|	СУММА(ТаблицаИзменений.СуммаИзменение)                        КАК СуммаИзменение,
	|	СУММА(ТаблицаИзменений.ОтгружаетсяИзменение)                  КАК ОтгружаетсяИзменение,
	|	СУММА(ТаблицаИзменений.ДопустимаяСуммаЗадолженностиИзменение) КАК ДопустимаяСуммаЗадолженностиИзменение
	|ПОМЕСТИТЬ ДвиженияРасчетыСКлиентамиИзменениеСуммыДолга
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Регистратор                              КАК Регистратор,
	|		Таблица.ЗаказКлиента                             КАК ЗаказКлиента,
	|		Таблица.Валюта                                   КАК Валюта,
	|		Таблица.СуммаПередЗаписью                        КАК СуммаИзменение,
	|		Таблица.ОтгружаетсяПередЗаписью                  КАК ОтгружаетсяИзменение,
	|		Таблица.ДопустимаяСуммаЗадолженностиПередЗаписью КАК ДопустимаяСуммаЗадолженностиИзменение
	|	ИЗ
	|		РасчетыСКлиентамиПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Регистратор                   КАК Регистратор,
	|		Таблица.ЗаказКлиента                  КАК ЗаказКлиента,
	|		Таблица.Валюта                        КАК Валюта,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|				ВЫБОР КОГДА Таблица.Сумма < 0 ТОГДА
	|						0
	|					ИНАЧЕ Таблица.Сумма
	|				КОНЕЦ
	|			ИНАЧЕ -Таблица.Сумма
	|		КОНЕЦ                                 КАК СуммаИзменение,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|				0
	|			ИНАЧЕ -Таблица.Отгружается
	|		КОНЕЦ                                 КАК ОтгружаетсяИзменение,
	|		-Таблица.ДопустимаяСуммаЗадолженности КАК ДопустимаяСуммаЗадолженностиИзменение
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентами КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И Таблица.ЗаказКлиента <> НЕОПРЕДЕЛЕНО

	|
	|) КАК ТаблицаИзменений
	|
	|ГДЕ
	|	&ПроведениеДокумента
	|	И НЕ &ОбменДанными
	|	И &РассчитыватьИзменения
	|	И НЕ ТИПЗНАЧЕНИЯ(ТаблицаИзменений.Регистратор) В (
	|		ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств),
	|		ТИП(Документ.ПриходныйКассовыйОрдер),
	|		ТИП(Документ.ОперацияПоПлатежнойКарте),
	|		ТИП(Документ.ВзаимозачетЗадолженности),
	|		ТИП(Документ.СписаниеЗадолженности)
	|		)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Регистратор,
	|	ТаблицаИзменений.ЗаказКлиента,
	|	ТаблицаИзменений.Валюта
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.СуммаИзменение) + СУММА(ТаблицаИзменений.ОтгружаетсяИзменение) < 0
	|	ИЛИ СУММА(ТаблицаИзменений.ДопустимаяСуммаЗадолженностиИзменение) > 0
	|;
	|ВЫБРАТЬ
	|	ТаблицаИзменений.Регистратор                                  КАК Регистратор,
	|	ТаблицаИзменений.ЗаказКлиента                                 КАК ЗаказКлиента,
	|	ТаблицаИзменений.Валюта                                       КАК Валюта,
	|	СУММА(ТаблицаИзменений.СуммаИзменение)                        КАК СуммаИзменение,
	|	СУММА(ТаблицаИзменений.КОплатеИзменениеКонтрольСрока)         КАК КОплатеИзменениеКонтрольСрока,
	|	СУММА(ТаблицаИзменений.ОплачиваетсяИзменениеКонтрольСрока)    КАК ОплачиваетсяИзменениеКонтрольСрока
	|ПОМЕСТИТЬ ДвиженияРасчетыСКлиентамиИзменениеКонтрольСрока
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Регистратор                              КАК Регистратор,
	|		Таблица.ЗаказКлиента                             КАК ЗаказКлиента,
	|		Таблица.Валюта                                   КАК Валюта,
	|		Таблица.СуммаПередЗаписью                        КАК СуммаИзменение,
	|		Таблица.КОплатеПередЗаписьюКонтрольСрока         КАК КОплатеИзменениеКонтрольСрока,
	|		Таблица.ОплачиваетсяПередЗаписьюКонтрольСрока    КАК ОплачиваетсяИзменениеКонтрольСрока
	|	ИЗ
	|		РасчетыСКлиентамиПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Регистратор                   КАК Регистратор,
	|		Таблица.ЗаказКлиента                  КАК ЗаказКлиента,
	|		Таблица.Валюта                        КАК Валюта,
	|		ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|				ВЫБОР КОГДА Таблица.Сумма < 0 ТОГДА
	|						0
	|					ИНАЧЕ Таблица.Сумма
	|				КОНЕЦ
	|			ИНАЧЕ -Таблица.Сумма
	|		КОНЕЦ                                 КАК СуммаИзменение,
	|		ВЫБОР КОГДА Таблица.Период <= &ПериодКонтроляСрокаДолга ТОГДА
	|			ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|					Таблица.КОплате
	|				ИНАЧЕ -Таблица.КОплате
	|			КОНЕЦ
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ                                 КАК КОплатеИзменениеКонтрольСрока,
	|		ВЫБОР КОГДА Таблица.Период <= &ПериодКонтроляСрокаДолга ТОГДА
	|			ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|					-Таблица.Оплачивается
	|				ИНАЧЕ Таблица.Оплачивается
	|			КОНЕЦ
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ                                 КАК ОплачиваетсяИзменениеКонтрольСрока
	|	ИЗ
	|		РегистрНакопления.РасчетыСКлиентами КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И Таблица.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
	|
	|) КАК ТаблицаИзменений
	|
	|ГДЕ
	|	&ПроведениеДокумента
	|	И НЕ &ОбменДанными
	|	И &РассчитыватьИзменения
	|	И НЕ ТИПЗНАЧЕНИЯ(ТаблицаИзменений.Регистратор) В (
	|		ТИП(Документ.ПоступлениеБезналичныхДенежныхСредств),
	|		ТИП(Документ.ПриходныйКассовыйОрдер),
	|		ТИП(Документ.ОперацияПоПлатежнойКарте),
	|		ТИП(Документ.ВзаимозачетЗадолженности),
	|		ТИП(Документ.СписаниеЗадолженности)
	|		)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Регистратор,
	|	ТаблицаИзменений.ЗаказКлиента,
	|	ТаблицаИзменений.Валюта
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.СуммаИзменение) < 0
	|	ИЛИ (СУММА(ТаблицаИзменений.КОплатеИзменениеКонтрольСрока)
	|			+ СУММА(ТаблицаИзменений.ОплачиваетсяИзменениеКонтрольСрока)) < 0
	|;
	|/////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Месяц,
	|	Таблица.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказКлиента                 КАК ОбъектРасчетов,
	|	Таблица.Регистратор                  КАК Документ
	|ПОМЕСТИТЬ РасчетыСКлиентамиЗаданияКРасчетамСКлиентами
	|ИЗ
	|	(ВЫБРАТЬ
	|		Расчеты.Регистратор                   КАК Регистратор,
	|		Расчеты.Период                        КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам     КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказКлиента                  КАК ЗаказКлиента,
	|		Расчеты.Валюта                        КАК Валюта,
	|		Расчеты.Сумма                         КАК Сумма,
	|		Расчеты.Оплачивается                  КАК Оплачивается,
	|		Расчеты.Отгружается                   КАК Отгружается,
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Расчеты.СуммаРегл                     КАК СуммаРегл,
	|		Расчеты.СуммаУпр                      КАК СуммаУпр,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|		ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Расчеты.Сумма > 0
	|			ТОГДА 0
	|			КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Расчеты.Сумма < 0
	|			ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК ИндексДвиженияВзаимозачета
	|	ИЗ РасчетыСКлиентамиИсходныеДвижения КАК Расчеты
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Расчеты.Регистратор                   КАК Регистратор,
	|		Расчеты.Период                        КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам     КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказКлиента                  КАК ЗаказКлиента,
	|		Расчеты.Валюта                        КАК Валюта,
	|		-Расчеты.Сумма                        КАК Сумма,
	|		-Расчеты.Оплачивается                 КАК Оплачивается,
	|		-Расчеты.Отгружается                  КАК Отгружается,
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		-Расчеты.СуммаРегл                    КАК СуммаРегл,
	|		-Расчеты.СуммаУпр                     КАК СуммаУпр,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|		ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Расчеты.Сумма > 0
	|			ТОГДА 0
	|			КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И Расчеты.Сумма < 0
	|			ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК ИндексДвиженияВзаимозачета
	|	ИЗ РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|	ГДЕ Расчеты.Регистратор = &Регистратор
	|		И Расчеты.Сумма <> 0
	|) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказКлиента,
	|	Таблица.Валюта,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|	Таблица.ИндексДвиженияВзаимозачета
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Сумма) <> 0
	|	ИЛИ СУММА(Таблица.СуммаРегл) <> 0
	|	ИЛИ СУММА(Таблица.СуммаУпр) <> 0
	|;
	|////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РасчетыСКлиентамиПередЗаписью;
	|////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РасчетыСКлиентамиИсходныеДвижения;
	|");
	
	Запрос.УстановитьПараметр("Регистратор",              Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ПроведениеДокумента",      ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение);
	Запрос.УстановитьПараметр("ПериодКонтроляСрокаДолга", Макс(КонецДня(ТекущаяДатаСеанса()), КонецДня(ДополнительныеСвойства.ДатаРегистратора)));
	Запрос.УстановитьПараметр("ОбменДанными",             ОбменДанными.Загрузка);
	Запрос.УстановитьПараметр("РассчитыватьИзменения",    ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства));

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;

	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВыборкаИзменение = МассивРезультатов[0].Выбрать();
	ВыборкаИзменение.Следующий();
	ВыборкаИзменениеСуммыДолга = МассивРезультатов[1].Выбрать();
	ВыборкаИзменениеСуммыДолга.Следующий();
	ВыборкаИзменениеКонтрольСрока = МассивРезультатов[2].Выбрать();
	ВыборкаИзменениеКонтрольСрока.Следующий();

	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСКлиентамиИзменение", ВыборкаИзменение.Количество > 0);
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСКлиентамиИзменениеСуммыДолга", ВыборкаИзменениеСуммыДолга.Количество > 0);
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСКлиентамиИзменениеКонтрольСрока", ВыборкаИзменениеКонтрольСрока.Количество > 0);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоРасчетамСКлиентами(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты.ВыгрузитьКолонку("ОбъектОплаты"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу заказов, которые были раньше в движениях и которые сейчас будут записаны
//
Процедура СФормироватьТаблицуОбъектовОплаты()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ЗаказКлиента КАК ОбъектОплаты
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И Таблица.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
	|";
	
	ТаблицаОбъектовОплаты = Запрос.Выполнить().Выгрузить();
	
	ТаблицаНовыхОбъектовОплаты = Выгрузить(, "ЗаказКлиента");
	ТаблицаНовыхОбъектовОплаты.Свернуть("ЗаказКлиента");
	Для Каждого Запись Из ТаблицаНовыхОбъектовОплаты Цикл
		Если Не ЗначениеЗаполнено(Запись.ЗаказКлиента) Тогда
			Продолжить;
		КонецЕсли;
		Если ТаблицаОбъектовОплаты.Найти(Запись.ЗаказКлиента, "ОбъектОплаты") = Неопределено Тогда
			ТаблицаОбъектовОплаты.Добавить().ОбъектОплаты = Запись.ЗаказКлиента;
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаОбъектовОплаты", ТаблицаОбъектовОплаты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли