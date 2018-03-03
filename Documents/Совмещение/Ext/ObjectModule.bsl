﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииЗаполненияДокумента

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
КонецПроцедуры
// Подсистема "Управление доступом".

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение физических лиц по сотрудникам.
	// В документе два реквизита с типом "Справочник.Сотрудники", в силу этой особенности
	// типовой механизм через подписки на события не подошел.
	ЭтотОбъект.ФизическиеЛица.Очистить();
	
	Сотрудники = Новый Массив;
	Сотрудники.Добавить(СовмещающийСотрудник);
	Сотрудники.Добавить(ОтсутствующийСотрудник);
	
	ФизическиеЛицаДокумента = КадровыйУчет.ФизическиеЛицаСотрудников(Сотрудники);
	
	Для Каждого ФизическоеЛицо Из ФизическиеЛицаДокумента Цикл
		СтрокаФизическогоЛица = ЭтотОбъект.ФизическиеЛица.Добавить();
		СтрокаФизическогоЛица.ФизическоеЛицо = ФизическоеЛицо;
	КонецЦикла;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если ЭтоНовый() Тогда 
		СсылкаНаОбъект = Документы.Совмещение.ПолучитьСсылку();
		УстановитьСсылкуНового(СсылкаНаОбъект);
		Отбор = Новый Структура("Начисление, ДокументОснование", Начисление, Документы.Совмещение.ПустаяСсылка());
		СтрокиНачислений = НачисленияСотрудника.НайтиСтроки(Отбор);
		Если СтрокиНачислений.Количество() > 0 Тогда 
			СтрокиНачислений[0].ДокументОснование = СсылкаНаОбъект;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Начало совмещения'"), , , Ложь);
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	Если ПричинаСовмещения <> Перечисления.ПричиныСовмещения.ИсполнениеОбязанностей Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОтсутствующийСотрудник");
	КонецЕсли;
	
	Если ПричинаСовмещения <> Перечисления.ПричиныСовмещения.СовмещениеПрофессийДолжностей Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СовмещаемаяДолжность");
	КонецЕсли;
	
	Если Не РазмерДоплатыУтвержден Или Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Начисление");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "РазмерДоплаты");
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПроверитьПериодРегистратораНачисленийУдержаний(ДатаНачала, ДатаОкончания, ЭтотОбъект, "ДатаОкончания", Отказ);
	
	ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
		СовмещающийСотрудник = ДанныеЗаполнения;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Сотрудник") Тогда
		СовмещающийСотрудник = ДанныеЗаполнения.Сотрудник;
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, СовмещающийСотрудник);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Отпуск") Тогда
		ЗаполнитьРеквизитыПоОснованию(ДанныеЗаполнения, "ДатаНачалаПериодаОтсутствия", "ДатаОкончанияПериодаОтсутствия");
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.БольничныйЛист")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Командировка")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОплатаПоСреднемуЗаработку")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОтпускБезСохраненияОплаты")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОтпускПоУходуЗаРебенком")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПрогулНеявка") Тогда
		ЗаполнитьРеквизитыПоОснованию(ДанныеЗаполнения, "ДатаНачала", "ДатаОкончания");
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
			Для Каждого СтрокаНачислений Из НачисленияСотрудника Цикл 
				Если СтрокаНачислений.ДокументОснование = ИсправленныйДокумент Тогда 
					СтрокаНачислений.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить;
					СтрокаНачислений.Размер = 0;
				КонецЕсли;
			КонецЦикла;
			
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПроведения = ДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеПроведения.СотрудникиДаты, Ссылка);
	
	Если Не РазмерДоплатыУтвержден Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеПроведения.ПлановыеНачисления);
	СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеПроведения.ЗначенияПоказателей);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
	
	ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетПлановыхНачислений(Движения, ДанныеПроведения.ОтражениеВБухучете);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура; 
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("РазмерДоплатыЗаСовмещение", ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.РазмерДоплатыЗаСовмещение"));
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СовмещениеНачисления.Ссылка.ДатаНачала КАК ДатаСобытия,
		|	ВЫБОР
		|		КОГДА СовмещениеНачисления.Ссылка.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(СовмещениеНачисления.Ссылка.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ СовмещениеНачисления.Ссылка.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо,
		|	СовмещениеНачисления.Ссылка.СовмещающийСотрудник КАК Сотрудник,
		|	СовмещениеНачисления.Начисление,
		|	ВЫБОР
		|		КОГДА СовмещениеНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Используется,
		|	ВЫБОР
		|		КОГДА СовмещениеНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ИСТИНА
		|		КОГДА СовмещениеНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ИспользуетсяПоОкончании,
		|	СовмещениеНачисления.Размер КАК Размер,
		|	СовмещениеНачисления.Ссылка.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СовмещениеНачисления.Ссылка.СовмещающийСотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ВЫБОР
		|		КОГДА СовмещениеНачисления.Начисление = СовмещениеНачисления.Ссылка.Начисление
		|				И СовмещениеНачисления.ДокументОснование = ЗНАЧЕНИЕ(Документ.Совмещение.ПустаяСсылка)
		|			ТОГДА СовмещениеНачисления.Ссылка
		|		ИНАЧЕ СовмещениеНачисления.ДокументОснование
		|	КОНЕЦ КАК ДокументОснование
		|ИЗ
		|	Документ.Совмещение.НачисленияСотрудника КАК СовмещениеНачисления
		|ГДЕ
		|	СовмещениеНачисления.Ссылка = &Ссылка";
	
	// Первый набор данных для проведения - таблица для формирования плановых начислений.
	ПлановыеНачисления = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Совмещение.ДатаНачала КАК ДатаСобытия,
		|	ВЫБОР
		|		КОГДА Совмещение.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(Совмещение.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ Совмещение.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо,
		|	Совмещение.СовмещающийСотрудник КАК Сотрудник,
		|	Совмещение.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Совмещение.Организация,
		|	&РазмерДоплатыЗаСовмещение КАК Показатель,
		|	Совмещение.Ссылка КАК ДокументОснование,
		|	Совмещение.РазмерДоплаты КАК Значение
		|ПОМЕСТИТЬ ВТПоказатели
		|ИЗ
		|	Документ.Совмещение КАК Совмещение
		|ГДЕ
		|	Совмещение.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Совмещение.ДатаНачала,
		|	ВЫБОР
		|		КОГДА Совмещение.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(Совмещение.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ Совмещение.ДатаОкончания
		|	КОНЕЦ,
		|	Совмещение.СовмещающийСотрудник,
		|	Совмещение.СовмещающийСотрудник.ФизическоеЛицо,
		|	Совмещение.Организация,
		|	СовмещениеПоказатели.Показатель,
		|	СовмещениеПоказатели.Ссылка,
		|	СовмещениеПоказатели.Значение
		|ИЗ
		|	Документ.Совмещение.Показатели КАК СовмещениеПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Совмещение КАК Совмещение
		|		ПО СовмещениеПоказатели.Ссылка = Совмещение.Ссылка
		|			И (СовмещениеПоказатели.Ссылка = &Ссылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Показатели.ДатаСобытия,
		|	Показатели.ДействуетДо,
		|	Показатели.Сотрудник,
		|	Показатели.ФизическоеЛицо,
		|	Показатели.Организация,
		|	Показатели.Показатель,
		|	Показатели.ДокументОснование,
		|	МАКСИМУМ(Показатели.Значение) КАК Значение
		|ИЗ
		|	ВТПоказатели КАК Показатели
		|
		|СГРУППИРОВАТЬ ПО
		|	Показатели.ДатаСобытия,
		|	Показатели.ДействуетДо,
		|	Показатели.Сотрудник,
		|	Показатели.ФизическоеЛицо,
		|	Показатели.Организация,
		|	Показатели.Показатель,
		|	Показатели.ДокументОснование";
	
	// Второй набор данных для проведения - таблица для формирования значений показателей.
	ЗначенияПоказателей = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Совмещение.ДатаНачала КАК ДатаСобытия,
		|	Совмещение.СовмещающийСотрудник КАК Сотрудник
		|ИЗ
		|	Документ.Совмещение КАК Совмещение
		|ГДЕ
		|	Совмещение.Ссылка = &Ссылка";
	
	// Третий набор данных для проведения - таблица для формирования времени регистрации документа.
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Совмещение.ДатаНачала КАК Период,
		|	Совмещение.СовмещающийСотрудник КАК Сотрудник,
		|	Совмещение.Организация,
		|	Совмещение.Начисление,
		|	Совмещение.СпособОтраженияЗарплатыВБухучете,
		|	Совмещение.СтатьяФинансирования,
		|	Совмещение.СтатьяРасходов,
		|	Совмещение.ОтношениеКЕНВД,
		|	Совмещение.ДатаОкончания КАК ДействуетДо,
		|	ИСТИНА КАК Используется,
		|	Совмещение.Ссылка КАК ДокументОснование
		|ИЗ
		|	Документ.Совмещение КАК Совмещение
		|ГДЕ
		|	Совмещение.Ссылка = &Ссылка
		|	И (Совмещение.СпособОтраженияЗарплатыВБухучете <> ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка)
		|			ИЛИ Совмещение.СтатьяФинансирования <> ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка)
		|			ИЛИ Совмещение.СтатьяРасходов <> ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка)
		|			ИЛИ Совмещение.ОтношениеКЕНВД <> ЗНАЧЕНИЕ(Перечисление.ОтношениеКЕНВДЗатратНаЗарплату.ПустаяСсылка))";
	
	// Четвертый набор данных для проведения - таблица для формирования отражения доплаты за совмещение в бухучете.
	ОтражениеВБухучете = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ОтражениеВБухучете", ОтражениеВБухучете);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Совмещение.ДатаНачала КАК ДатаСобытия,
		|	Совмещение.СовмещающийСотрудник КАК Сотрудник,
		|	Совмещение.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Совмещение.СовокупнаяТарифнаяСтавка КАК Значение,
		|	ВЫБОР
		|		КОГДА Совмещение.СовокупнаяТарифнаяСтавка = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
		|		ИНАЧЕ Совмещение.ВидТарифнойСтавки
		|	КОНЕЦ КАК ВидТарифнойСтавки,
		|	ВЫБОР
		|		КОГДА Совмещение.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(Совмещение.ДатаОкончания, ДЕНЬ, 1)
		|		ИНАЧЕ Совмещение.ДатаОкончания
		|	КОНЕЦ КАК ДействуетДо
		|ИЗ
		|	Документ.Совмещение КАК Совмещение
		|ГДЕ
		|	Совмещение.Ссылка = &Ссылка";
	
	// Пятый набор данных для проведения - таблица для формирования значений совокупных тарифных ставок.
	ДанныеСовокупныхТарифныхСтавок = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура ЗаполнитьРеквизитыПоОснованию(ДокументОснование, ДатаНачалаИзОснования, ДатаОкончанияИзОснования)
	
	СтрокаПодстановки = "Организация, Сотрудник, %1, %2";
	СписокРеквизитов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, ДатаНачалаИзОснования, ДатаОкончанияИзОснования);
	
	РеквизитыДокументаОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, СписокРеквизитов);

	Организация = РеквизитыДокументаОснования.Организация;
	ОтсутствующийСотрудник = РеквизитыДокументаОснования.Сотрудник;
	ДатаНачала = РеквизитыДокументаОснования[ДатаНачалаИзОснования];
	ДатаОкончания = РеквизитыДокументаОснования[ДатаОкончанияИзОснования];
	ПричинаСовмещения = Перечисления.ПричиныСовмещения.ИсполнениеОбязанностей;

КонецПроцедуры

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.СовмещающийСотрудник КАК Сотрудник,
		|	ТаблицаДокумента.ДатаНачала КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.Совмещение КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.СовмещающийСотрудник,
		|	ТаблицаДокумента.ДатаОкончания,
		|	ТаблицаДокумента.Ссылка
		|ИЗ
		|	Документ.Совмещение КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|	И ТаблицаДокумента.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЦепочкиДокументов") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЦепочкиДокументов");
		Модуль.УстановитьВторичныеРеквизитыДокументаЗамещения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
