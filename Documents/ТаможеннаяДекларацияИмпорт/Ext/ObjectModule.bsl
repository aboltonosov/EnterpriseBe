﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	НепроверяемыеРеквизиты = Новый Массив;
	// проверка реквизитов Объекта
	Если Перечисления.ХозяйственныеОперации.ОформлениеГТДСамостоятельно = ВариантОформления Тогда
		НепроверяемыеРеквизиты.Добавить("Соглашение");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		НепроверяемыеРеквизиты.Добавить("Договор");
	КонецЕсли;
	Если ТаможенныйШтраф = 0 Тогда
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходовШтраф");
	КонецЕсли;
	Если ТаможенныйСбор = 0 Тогда
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходовСбор");
	КонецЕсли;
	// проверка табчасти Разделы
	Шаблон = НСтр("ru='""%СинонимПоля%"" в строке %НомерСтроки% списка ""%ИмяТабчасти%"" необходимо заполнить.'");
	Для Каждого Раздел Из Разделы Цикл
		ПроверитьИСообщитьОшибку(Раздел.СтавкаПошлины<>0. И Раздел.СуммаПошлины=0.,
				Отказ, Шаблон, "СуммаПошлины", "Сумма пошлины", "Разделы", Раздел.НомерСтроки);
		ЗаполнитьНДС = Раздел.СтавкаНДС <> Перечисления.СтавкиНДС.БезНДС И Раздел.СтавкаНДС <> Перечисления.СтавкиНДС.НДС0;
		ПроверитьИСообщитьОшибку(ЗаполнитьНДС И Раздел.СуммаНДС=0.,
				Отказ, Шаблон, "СуммаНДС", "Сумма НДС", "Разделы", Раздел.НомерСтроки);
	КонецЦикла;
	
	// проверки и исключения, зависимые от статуса декларации
	Если Перечисления.СтатусыТаможенныхДеклараций.ТаможенноеОформление = Статус Тогда
		НепроверяемыеРеквизиты.Добавить("Товары");
		НепроверяемыеРеквизиты.Добавить("Товары.Склад");
		НепроверяемыеРеквизиты.Добавить("Товары.НомерРаздела");
		НепроверяемыеРеквизиты.Добавить("Товары.ТаможеннаяСтоимость");
		НепроверяемыеРеквизиты.Добавить("Товары.НомерДляСФ");
		НепроверяемыеРеквизиты.Добавить("Разделы.НомерДляСФ");
	ИначеЕсли Перечисления.СтатусыТаможенныхДеклараций.ВыпущеноСТаможни = Статус Тогда
		НепроверяемыеРеквизиты.Добавить(?(НумероватьПоТоварам, "Разделы.НомерДляСФ", "Товары.НомерДляСФ"));
		
		// проверка соответствия товаров и разделов
		КешРазделов = Новый Соответствие;
		Для Каждого Раздел Из Разделы Цикл
			Значение = Новый Структура("Раздел, ТаможеннаяСтоимость, СуммаПошлины, СуммаНДС", Раздел, 0., 0., 0.);
			КешРазделов.Вставить(Раздел.НомерРаздела, Значение);
		КонецЦикла;
		Для Каждого Товар Из Товары Цикл
			ЭлементКеша = КешРазделов[Товар.НомерРаздела];
			Если Неопределено <> ЭлементКеша Тогда
				ЭлементКеша.ТаможеннаяСтоимость = ЭлементКеша.ТаможеннаяСтоимость + Товар.ТаможеннаяСтоимость;
				ЭлементКеша.СуммаПошлины = ЭлементКеша.СуммаПошлины + Товар.СуммаПошлины;
				ЭлементКеша.СуммаНДС = ЭлементКеша.СуммаНДС + Товар.СуммаНДС;
			КонецЕсли;
		КонецЦикла;
		Шаблон = НСтр("ru='""%СинонимПоля%"" в строке %НомерСтроки% списка ""%ИмяТабчасти%"" не соответствует итогу по товарам раздела.'");
		Для Каждого ЭлементКеша Из КешРазделов Цикл
			Значение = ЭлементКеша.Значение;
			ПроверитьИСообщитьОшибку(Значение.Раздел.ТаможеннаяСтоимость<>Значение.ТаможеннаяСтоимость,
					Отказ, Шаблон, "ТаможеннаяСтоимость", "Таможенная стоимость", "Разделы", Значение.Раздел.НомерСтроки);
			ПроверитьИСообщитьОшибку(Значение.Раздел.СуммаПошлины<>Значение.СуммаПошлины,
					Отказ, Шаблон, "СуммаПошлины", "Сумма пошлины", "Разделы", Значение.Раздел.НомерСтроки);
			ПроверитьИСообщитьОшибку(Значение.Раздел.СуммаНДС<>Значение.СуммаНДС,
					Отказ, Шаблон, "СуммаНДС", "Сумма НДС", "Разделы", Значение.Раздел.НомерСтроки);
		КонецЦикла;
	КонецЕсли;
	// дополнительные проверки
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ТаможеннаяДекларацияИмпорт),
												Отказ,
												НепроверяемыеРеквизиты);
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,
		"СтатьяРасходовСбор, АналитикаРасходовСбор, СтатьяРасходовШтраф, АналитикаРасходовШтраф",
		НепроверяемыеРеквизиты,
		Отказ);
		
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ВариантОформления) Тогда
		НепроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	// корректировка НомерРаздела
	КешРазделов = Новый Соответствие;
	Для Каждого Раздел Из Разделы Цикл
		КешРазделов.Вставить(Раздел.НомерРаздела, 0);
	КонецЦикла;
	Для Каждого Товар Из Товары Цикл
		Если Неопределено=КешРазделов[Товар.НомерРаздела] Тогда
			Товар.НомерРаздела = 0;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Товар.ЗакупкаПодДеятельность) Тогда
			Товар.ЗакупкаПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
		КонецЕсли;
	КонецЦикла;
	
	Если Перечисления.ХозяйственныеОперации.ОформлениеГТДСамостоятельно = ВариантОформления Тогда
		Соглашение = Неопределено;
	КонецЕсли;
	
	ТабчастьОчистки = ?(НумероватьПоТоварам, Разделы, Товары);
	Для Каждого Строка Из ТабчастьОчистки Цикл
		Строка.НомерДляСФ = "";
	КонецЦикла;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов") Тогда
		Если Не ТаможенныйСбор = 0 Тогда
			ТаможенныйСбор = 0;
		КонецЕсли;
		Если Не ТаможенныйШтраф = 0 Тогда
			ТаможенныйШтраф = 0;
		КонецЕсли;
	КонецЕсли;
	
	СуммаДокумента = Документы.ТаможеннаяДекларацияИмпорт.СуммаДокумента(ЭтотОбъект);
	ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетов(ЭтотОбъект);
	
	Если РежимЗаписи=РежимЗаписиДокумента.Проведение Тогда
		Если (Статус = Перечисления.СтатусыТаможенныхДеклараций.ВыпущеноСТаможни) Тогда
			ЗаполнитьСклад();
			
			МенеджерАналитики = РегистрыСведений.АналитикаУчетаНоменклатуры;
			МестаУчета = МенеджерАналитики.МестаУчета(ВариантОформления, Неопределено, Подразделение, Неопределено);
			ИменаПолей = МенеджерАналитики.ИменаПолейКоллекцииПоУмолчанию();
			ИменаПолей.Произвольный = "Склад";
			МенеджерАналитики.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
			
			ВременныеТаблицы = ВременныеТаблицы();
			ЗаполнитьВидыЗапасовДокумента(ВременныеТаблицы);
			ЗаполнитьНомераГТД(ВременныеТаблицы);
			
		КонецЕсли;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Для Каждого Товар Из Товары Цикл
			Товар.ВидЗапасов = Неопределено;
		КонецЦикла;
	КонецЕсли;
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект, НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ТаможеннаяДекларацияИмпорт));
		
	// 4D:ERP для Беларуси, Дмитрий, 27.12.2016 10:08:20 
	// ЭСЧФ
	// {
	Документы.СчетФактураВыданный.ПроверитьРеквизитыСчетФактурыПередЗаписьюОснования(ЭтотОбъект);
	// }
	// 4D
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ТаможеннаяДекларацияИмпорт.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизацийКОформлению(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ДоходыИРасходыСервер.ОтразитьЖурналУчетаСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьНДСПредъявленный(ДополнительныеСвойства, Движения, Отказ);
	ПартионныйУчетСервер.ОтразитьПартииРасходовНаСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// 4D:ERP для Беларуси, Дмитрий, 27.12.2016 10:08:20 
	// ЭСЧФ
	// {
	Документы.СчетФактураВыданный.АктуализироватьСчетФактуру(ЭтотОбъект, Истина, Истина);
	РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОтразитьНеобходимостьОформленияСчетаФактуры(ДополнительныеСвойства, Отказ);
	// }
	// 4D
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// 4D:ERP для Беларуси, Дмитрий, 27.12.2016 10:08:20 
	// ЭСЧФ
	// {
	Документы.СчетФактураВыданный.АктуализироватьСчетФактуру(ЭтотОбъект, Ложь, Истина);
	РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОтразитьНеобходимостьОформленияСчетаФактуры(ДополнительныеСвойства, Отказ);
	// }
	// 4D
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Запрос = Новый Запрос();
	Реквизиты = Документы.ТаможеннаяДекларацияИмпорт.СтруктураЗаполнения();
	ТипДанных = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанных = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ХозяйственнаяОперация КАК ВариантОформления,
		|	Валюта КАК ВалютаПоступления,
		|	Дата КАК ДатаПоступления,
		|	ЦенаВключаетНДС КАК ЦенаВключаетНДС,
		|	Организация КАК Организация,
		|	Партнер КАК Поставщик,
		|	Проведен КАК Проведен,
		|	Контрагент КАК КонтрагентПоставщика,
		|	НаправлениеДеятельности КАК НаправлениеДеятельности
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг
		|ГДЕ
		|	Ссылка = &Ссылка
		|";
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения, , Не Выборка.Проведен);
			Если Выборка.ВариантОформления <> Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту Тогда
				Ошибка = НСтр("ru='Ввод таможенной декларации на основании поступления с операцией %Операция% не требуется.'");
				ВызватьИсключение СтрЗаменить(Ошибка, "%Операция%", Выборка.ВариантОформления);
			КонецЕсли;

			Запрос.Текст = "
			|ВЫБРАТЬ
			|	Строки.Номенклатура,
			|	Строки.Характеристика,
			|	Строки.Склад,
			|	Строки.Назначение,
			|	Строки.ВидЗапасов,
			|	СУММА(Строки.Количество) КАК Количество
			|
			|ПОМЕСТИТЬ Импорт
			|ИЗ
			|	Документ.ТаможеннаяДекларацияИмпорт КАК Импорт
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		Документ.ТаможеннаяДекларацияИмпорт.Товары КАК Строки
			|	ПО
			|		Строки.Ссылка = Импорт.Ссылка
			|ГДЕ
			|	Импорт.Проведен
			|	И Строки.ДокументПоступления = &Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	Строки.Номенклатура,
			|	Строки.Характеристика,
			|	Строки.Склад,
			|	Строки.Назначение,
			|	Строки.ВидЗапасов
			|;
			|///////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.Номенклатура,
			|	Товары.Характеристика,
			|	Товары.Серия,
			|	Товары.Назначение,
			|	Товары.СтавкаНДС,
			|	НЕОПРЕДЕЛЕНО КАК Упаковка,
			|	0 КАК Цена,
			|	Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0) КАК КоличествоУпаковок,
			|	Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0) КАК Количество,
			|	Товары.Сумма * (Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0)) / Товары.Количество КАК Сумма,
			|	Товары.СуммаНДС * (Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0)) / Товары.Количество КАК СуммаНДС,
			|	Товары.СуммаСНДС * (Товары.Количество - ЕСТЬNULL(Импорт.Количество, 0)) / Товары.Количество КАК СуммаСНДС,
			|	Товары.Склад,
			|	Товары.Ссылка КАК ДокументПоступления,
			|	Товары.Ссылка.ЗакупкаПодДеятельность КАК ЗакупкаПодДеятельность,
			|	Товары.ВидЗапасов
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг.Товары КАК Товары
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		Справочник.Номенклатура КАК НоменклатураСпр
			|	ПО
			|		НоменклатураСпр.Ссылка = Товары.Номенклатура
			|
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		Импорт КАК Импорт
			|	ПО
			|		Импорт.Номенклатура = Товары.Номенклатура
			|		И Импорт.Характеристика = Товары.Характеристика
			|		И Импорт.Склад = Товары.Склад
			|		И Импорт.Назначение = Товары.Назначение
			|		И Импорт.ВидЗапасов = Товары.ВидЗапасов
			|ГДЕ
			|	Товары.Ссылка = &Ссылка
			|	И Товары.Количество > 0.
			|	И НоменклатураСпр.ТипНоменклатуры В
			|		(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
			|";
			
			ЗаполнитьЗначенияСвойств(Реквизиты, Выборка);
			Реквизиты.Товары = Запрос.Выполнить().Выгрузить();
			Документы.ТаможеннаяДекларацияИмпорт.ЗаполнитьПоДанным(ЭтотОбъект, Реквизиты);
		КонецЕсли;
	ИначеЕсли ТипДанных = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Реквизиты, ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("ЗапросТовары") Тогда
			Запрос.Текст = ДанныеЗаполнения.ЗапросТовары;
			Для Каждого Свойство Из ДанныеЗаполнения Цикл
				Запрос.УстановитьПараметр(Свойство.Ключ, Свойство.Значение);
			КонецЦикла;
			Реквизиты.Товары = Запрос.Выполнить().Выгрузить();
		ИначеЕсли ДанныеЗаполнения.Свойство("Товары") Тогда
			Реквизиты.Товары = ДанныеЗаполнения.Товары;
		КонецЕсли;
		Документы.ТаможеннаяДекларацияИмпорт.ЗаполнитьПоДанным(ЭтотОбъект, Реквизиты);
	Иначе
		Документы.ТаможеннаяДекларацияИмпорт.ЗаполнитьПоУмолчанию(ЭтотОбъект);
	КонецЕсли;
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыЗаполненияЗначенийАвтоподстановкиВидыЗапасовНомераГтд

Функция ВременныеТаблицы()
	ВременныеТаблицы = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Товары.ВидЗапасов КАК ВидЗапасов,
	|	Товары.НомерРаздела КАК НомерРаздела,
	|	Товары.СтранаПроисхождения КАК СтранаПроисхождения,
	|	Товары.НомерДляСФ КАК НомерДляСФ,
	|	Товары.НомерГТД КАК НомерГТД
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРазделов.НомерРаздела КАК НомерРаздела,
	|	ТаблицаРазделов.НомерДляСФ КАК НомерДляСФ
	|
	|ПОМЕСТИТЬ Разделы
	|ИЗ
	|	&ТаблицаРазделов КАК ТаблицаРазделов
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|		Товары.НомерДляСФ
	|	ИНАЧЕ
	|		Разделы.НомерДляСФ
	|	КОНЕЦ КАК НомерДляСФ,
	|	Товары.СтранаПроисхождения
	|
	|ПОМЕСТИТЬ ГенерацияГТД
	|ИЗ
	|	Товары КАК Товары
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Разделы КАК Разделы
	|	ПО
	|		Разделы.НомерРаздела = Товары.НомерРаздела
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК УказанныеГТД
	|	ПО
	|		УказанныеГТД.Ссылка = Товары.НомерГТД
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК ПодобранныеГТД
	|	ПО
	|		ПодобранныеГТД.СтранаПроисхождения = Товары.СтранаПроисхождения
	|		И НЕ ПодобранныеГТД.ПометкаУдаления
	|		И ПодобранныеГТД.Код = (
	|			ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|				Товары.НомерДляСФ
	|			ИНАЧЕ
	|				Разделы.НомерДляСФ
	|			КОНЕЦ)
	|ГДЕ
	|	УказанныеГТД.Ссылка ЕСТЬ NULL
	|	И ПодобранныеГТД.Ссылка ЕСТЬ NULL
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Запрос.УстановитьПараметр("Товары",
		Товары.Выгрузить(, "НомерСтроки, АналитикаУчетаНоменклатуры, ВидЗапасов, НомерРаздела, СтранаПроисхождения, НомерДляСФ, НомерГТД"));
	Запрос.УстановитьПараметр("ТаблицаРазделов", Разделы.Выгрузить(, "НомерРаздела, НомерДляСФ"));
	Запрос.УстановитьПараметр("НумероватьПоТоварам", НумероватьПоТоварам);
	Запрос.Выполнить();
	Возврат ВременныеТаблицы;
КонецФункции

Процедура ЗаполнитьВидыЗапасовДокумента(ВременныеТаблицы)
	// спросим возможные остатки товаров к оформлению по аналитикам документа
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.АналитикаУчетаНоменклатуры
		|ПОМЕСТИТЬ АналитикиОтбора
		|ИЗ
		|	Товары КАК Товары
		|;
		|//////////////////////////////////////////
		|ВЫБРАТЬ
		|	Остатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|	Остатки.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
		|	Остатки.ВидЗапасов КАК ВидЗапасов,
		|	Остатки.ДокументПоступления КАК ДокументПоступления,
		|	СУММА(Остатки.Количество) КАК Количество
		|ИЗ
		|	(ВЫБРАТЬ
		|		Остатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|		Остатки.ВидЗапасов КАК ВидЗапасов,
		|		Остатки.ДокументПоступления КАК ДокументПоступления,
		|		Остатки.КоличествоОстаток КАК Количество
		|	ИЗ
		|		РегистрНакопления.ТоварыОрганизацийКОформлению.Остатки(,
		|			Организация = &Организация И Поставщик = &Поставщик
		|			И ВЫБОР КОГДА &КонтролироватьОстатки ТОГДА
		|				ДокументПоступления В (&ДокументыПоступления)
		|			ИНАЧЕ
		|				ИСТИНА
		|			КОНЕЦ
		|			И АналитикаУчетаНоменклатуры В (
		|				ВЫБРАТЬ
		|					Аналитика.АналитикаУчетаНоменклатуры
		|				ИЗ
		|					АналитикиОтбора КАК Аналитика)
		|		) КАК Остатки
		|	ГДЕ
		|		Остатки.КоличествоОстаток > 0
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		Движения.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|		Движения.ВидЗапасов КАК ВидЗапасов,
		|		Движения.ДокументПоступления КАК ДокументПоступления,
		|		Движения.Количество КАК Количество
		|	ИЗ
		|		РегистрНакопления.ТоварыОрганизацийКОформлению КАК Движения
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ АналитикиОтбора КАК АналитикиОтбора
		|		ПО Движения.АналитикаУчетаНоменклатуры = АналитикиОтбора.АналитикаУчетаНоменклатуры
		|	ГДЕ
		|		Движения.Регистратор = &Ссылка
		|		И Движения.Период <= &Период
		|
		|	) КАК Остатки
		|
		|СГРУППИРОВАТЬ ПО
		|	Остатки.АналитикаУчетаНоменклатуры,
		|	Остатки.АналитикаУчетаНоменклатуры.Назначение,
		|	Остатки.ВидЗапасов,
		|	Остатки.ДокументПоступления
		|
		|УПОРЯДОЧИТЬ ПО
		|	АналитикаУчетаНоменклатуры,
		|	ВидЗапасов
		|");
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	Запрос.УстановитьПараметр("ДокументыПоступления", Товары.ВыгрузитьКолонку("ДокументПоступления"));
	КонтролироватьОстатки = ПолучитьФункциональнуюОпцию("КонтролироватьОстаткиТоваровОрганизацийКОформлениюПоПоступлениям");
	Запрос.УстановитьПараметр("КонтролироватьОстатки", КонтролироватьОстатки);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	// зальем остатки в кеш
	Остатки = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Остаток = Остатки[Выборка.АналитикаУчетаНоменклатуры];
		Если Неопределено = Остаток Тогда
			Остаток = Новый Массив;
			Остатки.Вставить(Выборка.АналитикаУчетаНоменклатуры, Остаток);
		КонецЕсли;
		ОписаниеОстатка = Новый Структура;
		ОписаниеОстатка.Вставить("ВидЗапасов", Выборка.ВидЗапасов);
		ОписаниеОстатка.Вставить("Назначение", Выборка.Назначение);
		ОписаниеОстатка.Вставить("АналитикаУчетаНоменклатуры", Выборка.АналитикаУчетаНоменклатуры);
		ОписаниеОстатка.Вставить("Количество", Выборка.Количество);
		ОписаниеОстатка.Вставить("ДокументПоступления", Выборка.ДокументПоступления);
		
		Остаток.Добавить(ОписаниеОстатка);
	КонецЦикла;
	ВидЗапасовПоУмолчанию =
		Справочники.ВидыЗапасов.ВидЗапасовДокумента(Организация, ВариантОформления);
	// пройдемся по товарам и заберем остатки из кеша
	Для Каждого Товар Из Товары Цикл
		Остаток = Остатки[Товар.АналитикаУчетаНоменклатуры];
		Если Неопределено = Остаток Тогда
			// вид запасов не будет покрыт, заполним умолчание и получим нехватку остатков на контроле проведения
			Товар.ВидЗапасов = ВидЗапасовПоУмолчанию;
			Продолжить;
		КонецЕсли;
		// остатки в кеше были
		Количество = Товар.Количество;
		Указатель = 0;
		Пока Количество > 0. И Указатель < Остаток.Количество() Цикл
			ОстатокЗапаса = Остаток[Указатель];
			
			Если КонтролироватьОстатки И Товар.ДокументПоступления <> ОстатокЗапаса.ДокументПоступления Тогда
				Указатель = Указатель + 1;
				Продолжить;
			КонецЕсли;
			
			Если Количество <= ОстатокЗапаса.Количество Тогда
				Товар.ВидЗапасов = ОстатокЗапаса.ВидЗапасов;
				Товар.АналитикаУчетаНоменклатуры = ОстатокЗапаса.АналитикаУчетаНоменклатуры;
				Товар.Назначение = ОстатокЗапаса.Назначение;
				ОстатокЗапаса.Количество = ОстатокЗапаса.Количество - Количество;
				Количество = 0.;
			ИначеЕсли ОстатокЗапаса.Количество > 0. Тогда // из остатка покрывается только часть
				// создаем новую позицию на покрываемую остатком запаса часть
				НовыйТовар = Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйТовар, Товар);
				НовыйТовар.ВидЗапасов = ОстатокЗапаса.ВидЗапасов;
				НовыйТовар.АналитикаУчетаНоменклатуры = ОстатокЗапаса.АналитикаУчетаНоменклатуры;
				НовыйТовар.Назначение = ОстатокЗапаса.Назначение;
				НовыйТовар.Количество = ОстатокЗапаса.Количество;
				НовыйТовар.КоличествоУпаковок = 
					Окр(НовыйТовар.Количество * Товар.КоличествоУпаковок / Товар.Количество, 3);
				НовыйТовар.ТаможеннаяСтоимость = 
					Окр(НовыйТовар.Количество * Товар.ТаможеннаяСтоимость / Товар.Количество, 2);
				НовыйТовар.СуммаПошлины = 
					Окр(НовыйТовар.Количество * Товар.СуммаПошлины / Товар.Количество, 2);
				НовыйТовар.СуммаНДС = 
					Окр(НовыйТовар.Количество * Товар.СуммаНДС / Товар.Количество, 2);
				// изменяем старую позицию
				Товар.Количество = Товар.Количество - НовыйТовар.Количество;
				Товар.КоличествоУпаковок = Товар.КоличествоУпаковок - НовыйТовар.КоличествоУпаковок;
				Товар.ТаможеннаяСтоимость = Товар.ТаможеннаяСтоимость - НовыйТовар.ТаможеннаяСтоимость;
				Товар.СуммаПошлины = Товар.СуммаПошлины - НовыйТовар.СуммаПошлины;
				Товар.СуммаНДС = Товар.СуммаНДС - НовыйТовар.СуммаНДС;
				
				Количество = Товар.Количество;
				ОстатокЗапаса.Количество = 0;
			КонецЕсли;
			Указатель = Указатель + 1;
		КонецЦикла;
		// вид запасов остался не покрыт, заполним умолчание и получим нехватку остатков на контроле проведения
		Если Не ЗначениеЗаполнено(Товар.ВидЗапасов) Тогда
			Товар.ВидЗапасов = ВидЗапасовПоУмолчанию;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьНомераГТД(ВременныеТаблицы)
	
	// Создаем новые номера ГТД по временной таблице ГенерацияГТД.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ГенерацияГТД.НомерДляСФ,
	|	ГенерацияГТД.СтранаПроисхождения
	|ИЗ
	|	ГенерацияГТД КАК ГенерацияГТД
	|");
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НомерГТД = Справочники.НомераГТД.СоздатьЭлемент();
		НомерГТД.Код = Выборка.НомерДляСФ;
		НомерГТД.СтранаПроисхождения = Выборка.СтранаПроисхождения;
		НомерГТД.Записать();
	КонецЦикла;
	
	// Подбираем номера ГТД в товары.
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.СтранаПроисхождения,
	|	ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|		Товары.НомерДляСФ
	|	ИНАЧЕ
	|		Разделы.НомерДляСФ
	|	КОНЕЦ КАК НомерДляСФ,
	|	ПодобранныеГТД.Ссылка КАК НомерГТД
	|ИЗ
	|	Товары КАК Товары
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Разделы
	|	ПО
	|		Разделы.НомерРаздела = Товары.НомерРаздела
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК УказанныеГТД
	|	ПО
	|		УказанныеГТД.Ссылка = Товары.НомерГТД
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.НомераГТД КАК ПодобранныеГТД
	|	ПО
	|		ПодобранныеГТД.СтранаПроисхождения = Товары.СтранаПроисхождения
	|		И НЕ ПодобранныеГТД.ПометкаУдаления
	|		И ПодобранныеГТД.Код = (
	|			ВЫБОР КОГДА &НумероватьПоТоварам ТОГДА
	|				Товары.НомерДляСФ
	|			ИНАЧЕ
	|				Разделы.НомерДляСФ
	|			КОНЕЦ)
	|ГДЕ
	|	УказанныеГТД.Ссылка ЕСТЬ NULL
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|";
	Запрос.УстановитьПараметр("НумероватьПоТоварам", НумероватьПоТоварам);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		// слияние упорядоченных массивов, |Выборки| <= |Товары|
		Для Каждого Товар Из Товары Цикл
			Если ЗначениеЗаполнено(Товар.НомерГТД) Или Товар.НомерСтроки < Выборка.НомерСтроки Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Выборка.НомерГТД) Тогда
				ВызватьИсключение НСтр("ru='Обнаружены проблемы в подборе номеров ГТД!'");
			КонецЕсли;
			
			Товар.НомерГТД = Выборка.НомерГТД;

			Если Не Выборка.Следующий() Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	Массив = Новый Массив;
	// Приходы в регистр контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	// Расходы из регистра контролируем только при проведении
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ТоварыОрганизацийКОформлению);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
КонецПроцедуры

Процедура ПроверитьИСообщитьОшибку(УсловиеОшибки, Отказ, Знач Шаблон, Знач ИмяПоля, Знач СинонимПоля, Знач ИмяТабчасти = Неопределено, Знач НомерСтроки = Неопределено)
	Если УсловиеОшибки Тогда
		Сообщение = СтрЗаменить(Шаблон, "%СинонимПоля%", СинонимПоля);
		Сообщение = СтрЗаменить(Сообщение, "%НомерСтроки%", НомерСтроки);
		Сообщение = СтрЗаменить(Сообщение, "%ИмяТабчасти%", ИмяТабчасти);
		Если ЗначениеЗаполнено(ИмяТабчасти) И НомерСтроки > 0 Тогда
			ИмяПоля = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабчасти, НомерСтроки, ИмяПоля);
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, , ИмяПоля, "Объект", Отказ);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьСклад()
	Для Каждого Строка Из Товары Цикл
		Строка.Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Строка.Склад, Ложь, Истина);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
