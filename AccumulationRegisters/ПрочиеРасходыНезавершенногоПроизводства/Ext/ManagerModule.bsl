﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления КА 2.1.2
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства";
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КОбработке.Ссылка КАК Ссылка
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ДанныеРегистра.Регистратор КАК Ссылка
	|	ИЗ
	|		РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК ДанныеРегистра
	|	ГДЕ
	|		ДанныеРегистра.АналитикаУчетаПродукции.Назначение <> ДанныеРегистра.ВидЗапасов.УдалитьНазначение
	|		И ДанныеРегистра.ВидЗапасов.УдалитьНазначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		И ДанныеРегистра.ВидЗапасов <> ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		И ДанныеРегистра.АналитикаУчетаПродукции <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	// ПравилоОтнесенияНаВыпуск заполняется с даты перехода на ПУ 2.2
	//    дата перехода может быть не заполнена, если ПУ 2.2 был включен с самого начала
	|	ВЫБРАТЬ
	|		ДанныеРегистра.Регистратор КАК Ссылка
	|	ИЗ
	|		РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК ДанныеРегистра
	|	ГДЕ
	|		ДанныеРегистра.ПравилоОтнесенияНаВыпуск = ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПустаяСсылка)
	|		И &ИспользуетсяПартионныйУчет22
	|		И (&ДатаПерехода = ДАТАВРЕМЯ(1,1,1) ИЛИ ДанныеРегистра.Период >= &ДатаПерехода )
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	// ПравилоОтнесенияНаВыпуск очистка ошибочно заполненного измерения
	|	ВЫБРАТЬ
	|		ДанныеРегистра.Регистратор КАК Ссылка
	|	ИЗ
	|		РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК ДанныеРегистра
	|	ГДЕ
	|		ДанныеРегистра.ПравилоОтнесенияНаВыпуск <> ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПустаяСсылка)
	|		И НЕ (&ИспользуетсяПартионныйУчет22
	|			И (&ДатаПерехода = ДАТАВРЕМЯ(1,1,1) ИЛИ ДанныеРегистра.Период >= &ДатаПерехода ))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ДанныеРегистра.Регистратор КАК Ссылка
	|	ИЗ
	|		РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК ДанныеРегистра
	|	ГДЕ
	|		ДанныеРегистра.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) <> ТИП(Документ.РаспределениеПрочихЗатрат)
	|		И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) <> ТИП(Документ.КорректировкаРегистров)
	|		И ДанныеРегистра.АналитикаУчетаПродукции <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|	) КАК КОбработке
	|");
	
	ИспользуетсяПартионныйУчет22 = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22();
	ДатаПерехода = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22();
	
	Запрос.УстановитьПараметр("ИспользуетсяПартионныйУчет22", ИспользуетсяПартионныйУчет22);
	Запрос.УстановитьПараметр("ДатаПерехода", ДатаПерехода);
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления заполняет новый реквизит "Назначение" в справочнике "Ключи аналитики учета номенклатуры",
// и обновляет движения по регистру.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства";
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ПрочиеРасходыНезавершенногоПроизводства;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Движения.Регистратор) = ТИП(Документ.РаспределениеПрочихЗатрат)
	|		ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	КОГДА ТИПЗНАЧЕНИЯ(Движения.Регистратор) = ТИП(Документ.ОтчетПереработчика)
	|		И Движения.АналитикаУчетаПродукции = ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	КОГДА ТИПЗНАЧЕНИЯ(Движения.Регистратор) = ТИП(Документ.КорректировкаРегистров)
	|		ТОГДА Движения.ВидДвижения
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ                           КАК ВидДвижения,
	|	Движения.Регистратор            КАК Регистратор,
	|	Движения.Период                 КАК Период,
	|	Движения.Организация                  КАК Организация,
	|	Движения.Подразделение                КАК Подразделение,
	|	Движения.ЗаказНаПроизводство          КАК ЗаказНаПроизводство,
	|	Движения.КодСтрокиПродукция           КАК КодСтрокиПродукция,
	|	Движения.Этап                         КАК Этап,
	|	Движения.СтатьяКалькуляции            КАК СтатьяКалькуляции,
	|	Движения.СтатьяРасходов               КАК СтатьяРасходов,
	|	Движения.АналитикаРасходов            КАК АналитикаРасходов,
	|	Движения.ГруппаПродукции              КАК ГруппаПродукции,
	|	Движения.Стоимость               КАК Стоимость,
	|	Движения.СтоимостьБезНДС         КАК СтоимостьБезНДС,
	|	Движения.СтоимостьРегл           КАК СтоимостьРегл,
	|	Движения.ПостояннаяРазница       КАК ПостояннаяРазница,
	|	Движения.ВременнаяРазница        КАК ВременнаяРазница,
	|	Движения.ДоляСтоимости           КАК ДоляСтоимости,
	|	Движения.ДоляСтоимости           КАК ПоказательОтнесенияНаВыпуск,
	|	Движения.Продукция                    КАК Продукция,
	|	Движения.ХарактеристикаПродукции      КАК ХарактеристикаПродукции,
	|	Движения.КоличествоПродукции          КАК КоличествоПродукции,
	|	ВЫБОР КОГДА НЕ Аналитика.КлючАналитики ЕСТЬ NULL
	|		И Движения.АналитикаУчетаПродукции.Назначение <> Движения.ВидЗапасов.УдалитьНазначение
	|		И Движения.ВидЗапасов.УдалитьНазначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		И Движения.ВидЗапасов <> ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		И Движения.АналитикаУчетаПродукции <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|		ТОГДА Аналитика.КлючАналитики
	|		ИНАЧЕ Движения.АналитикаУчетаПродукции
	|	КОНЕЦ                                 КАК АналитикаУчетаПродукции,
	|	Движения.РазделУчета                  КАК РазделУчета,
	|	Движения.ВидЗапасов                   КАК ВидЗапасов,
	|	Движения.ДокументДвижения             КАК ДокументДвижения,
	|	Движения.ДокументИсточник             КАК ДокументИсточник,
	|	Движения.ДокументВыпуска              КАК ДокументВыпуска,
	|	Движения.РасчетСебестоимости          КАК РасчетСебестоимости,
	|	Движения.РасчетПартий                 КАК РасчетПартий,
	|	Движения.АналитикаУчетаПартийПроизводства КАК АналитикаУчетаПартийПроизводства,
	|
	|	ВЫБОР КОГДА Аналитика.КлючАналитики ЕСТЬ NULL
	|		И Движения.АналитикаУчетаПродукции.Назначение <> Движения.ВидЗапасов.УдалитьНазначение
	|		И Движения.ВидЗапасов.УдалитьНазначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|		И Движения.ВидЗапасов <> ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		И Движения.АналитикаУчетаПродукции <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
	|		ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ                                 КАК КлючиИнициализированы,
	|	ВЫБОР 
	|		КОГДА НЕ (&ИспользуетсяПартионныйУчет22
	|			И (&ДатаПерехода = ДАТАВРЕМЯ(1,1,1) ИЛИ Движения.Период >= &ДатаПерехода))
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПустаяСсылка)
	|		КОГДА ЕСТЬNULL(ДД1.БазаРаспределенияПоЭтапам, ДД2.БазаРаспределенияПоЭтапам) = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПоМатериальнымИТрудозатратам)
	|		КОГДА ЕСТЬNULL(ДД1.БазаРаспределенияПоЭтапам, ДД2.БазаРаспределенияПоЭтапам) В (ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.СуммаРасходовНаОплатуТруда),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.КоличествоРаботУказанныхВидов),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда))
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПоТрудозатратам)
	|		КОГДА ЕСТЬNULL(ДД1.БазаРаспределенияПоЭтапам, ДД2.БазаРаспределенияПоЭтапам) В (ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхЗатрат),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.НормативРасходаМатериала),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.КоличествоУказанныхМатериалов),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ОбъемУказанныхМатериалов),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ВесУказанныхМатериалов))
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПоМатериальнымЗатратам)
	|		КОГДА ЕСТЬNULL(ДД1.БазаРаспределенияПоЭтапам, ДД2.БазаРаспределенияПоЭтапам) В (ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.КоличествоПродукции),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ВесПродукции),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ОбъемПродукции),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ПлановаяСтоимостьПродукции))
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПоПродукции)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПравилаОтнесенияНаВыпуск.ПоПродукции)
	|	КОНЕЦ                                 КАК ПравилоОтнесенияНаВыпуск
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК Движения
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Ключи
	|	ПО Ключи.Ссылка = Движения.АналитикаУчетаПродукции
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО Ключи.Номенклатура = Аналитика.Номенклатура
	|		И Ключи.Характеристика = Аналитика.Характеристика
	|		И Ключи.Серия = Аналитика.Серия
	|		И Ключи.Склад = Аналитика.Склад
	|		И Движения.ВидЗапасов.УдалитьНазначение = Аналитика.Назначение
	|		И Ключи.СтатьяКалькуляции = Аналитика.СтатьяКалькуляции
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РаспределениеПрочихЗатрат КАК ДД1
	|	ПО Движения.Регистратор ССЫЛКА Документ.РаспределениеПрочихЗатрат
	|		И ДД1.Ссылка = &Регистратор
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.РаспределениеПрочихЗатрат КАК ДД2
	|	ПО НЕ Движения.Регистратор ССЫЛКА Документ.РаспределениеПрочихЗатрат
	|		И Движения.ДокументИсточник = ДД2.Ссылка
	|
	|ГДЕ
	|	Движения.Регистратор = &Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючиИнициализированы,
	|	НомерСтроки
	|";
	
	ИспользуетсяПартионныйУчет22 = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22();
	ДатаПерехода = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22();
	
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			Блокировка.Заблокировать();
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Регистратор", Регистратор);
			Запрос.УстановитьПараметр("ИспользуетсяПартионныйУчет22", ИспользуетсяПартионныйУчет22);
			Запрос.УстановитьПараметр("ДатаПерехода", ДатаПерехода);
			
			Набор = РегистрыНакопления.ПрочиеРасходыНезавершенногоПроизводства.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Регистратор);
			
			Результат = Запрос.Выполнить().Выгрузить();
			Если Результат.Количество() = 0 Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Регистратор, ДополнительныеПараметры);
				ЗафиксироватьТранзакцию();
				Продолжить;
			ИначеЕсли Результат[0].КлючиИнициализированы = 0 Тогда
				ТекстСообщения = НСтр("ru = 'есть необновленные ключи. Необходимо перепровести документ вручную.'");
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
			
			Набор.Загрузить(Результат);
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
				Регистратор.Метаданные(), ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли