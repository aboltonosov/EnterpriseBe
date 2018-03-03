﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	Возврат; //В дальнейшем будет добавлен код команд

КонецПроцедуры

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

// Метод создает документы Амортизации ОС в указанном месяце.
//
// Параметры:
// 		Месяц - Дата - Начало месяца, в котором необходимо создать документы амортизации.
// 		Организация - Массив, Неопределено - Список организаций по которым формируются документы. Если список пустой, то документы формируются по всем организациям.
// 		Отказ - Булево - Используется при вызове из формы закрытия месяца. При установке в "Истина" - дальнейшие операции выполняться не будут.
//
Процедура СоздатьДокументыАмортизацииОС(Месяц, Организация = Неопределено, Отказ = Ложь) Экспорт
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Начисление амортизации ОС'"));
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкаАмортизации.Организация
	|ПОМЕСТИТЬ НачислениеАмортизации
	|ИЗ
	|	РегистрСведений.НачислениеАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&КонецПериода,
	|			Организация = &Организация
	|				ИЛИ &ПоВсемОрганизациям) КАК НастройкаАмортизации
	|ГДЕ
	|	НастройкаАмортизации.НачислятьАмортизацию
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаАмортизации.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЕСТЬNULL(АмортизацияОС.Проведен, ЛОЖЬ) = ИСТИНА
	|				ТОГДА АмортизацияОС.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.АмортизацияОС.ПустаяСсылка)
	|		КОНЕЦ) КАК СсылкаПроведен,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЕСТЬNULL(АмортизацияОС.Проведен, НЕОПРЕДЕЛЕНО) = ЛОЖЬ
	|				ТОГДА АмортизацияОС.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.АмортизацияОС.ПустаяСсылка)
	|		КОНЕЦ) КАК СсылкаНеПроведен,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЕСТЬNULL(АмортизацияОС.ПометкаУдаления, ЛОЖЬ) = ИСТИНА
	|				ТОГДА АмортизацияОС.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.АмортизацияОС.ПустаяСсылка)
	|		КОНЕЦ) КАК СсылкаУдален
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ НачислениеАмортизации КАК НачислениеАмортизации
	|		ПО (НачислениеАмортизации.Организация = Организации.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АмортизацияОС КАК АмортизацияОС
	|		ПО Организации.Ссылка = АмортизацияОС.Организация
	|			И (АмортизацияОС.Дата >= &НачалоПериода)
	|			И (АмортизацияОС.Дата <= &КонецПериода)
	|ГДЕ
	|	(Организации.Ссылка = &Организация
	|			ИЛИ &ПоВсемОрганизациям)
	|	И НЕ НачислениеАмортизации.Организация ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	Организации.Ссылка,
	|	НЕ НачислениеАмортизации.Организация ЕСТЬ NULL";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Месяц));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Месяц));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(Организация));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.СсылкаПроведен.Пустая()
			И Выборка.СсылкаНеПроведен.Пустая()
			И Выборка.СсылкаУдален.Пустая() Тогда
			
			ДокументОбъект = Документы.АмортизацияОС.СоздатьДокумент();
			
		ИначеЕсли НЕ Выборка.СсылкаПроведен.Пустая() Тогда
			
			ДокументОбъект = Выборка.СсылкаПроведен.ПолучитьОбъект();
			
		ИначеЕсли НЕ Выборка.СсылкаНеПроведен.Пустая() Тогда
			
			ДокументОбъект = Выборка.СсылкаНеПроведен.ПолучитьОбъект();
			ДокументОбъект.ПометкаУдаления = Ложь;
			
		Иначе
			
			ДокументОбъект = Выборка.СсылкаУдален.ПолучитьОбъект();
			ДокументОбъект.ПометкаУдаления = Ложь;
			
		КонецЕсли; 
		
		ДокументОбъект.Организация = Выборка.Организация;
		ДокументОбъект.Дата = КонецМесяца(Месяц);
		ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Амортизация и износ основных средств'"));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	ТекстыЗапроса = Новый СписокЗначений;
	УчетОСВызовСервера.ПрочиеРасходы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПрочиеДоходы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПрочиеАктивыПассивы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПорядокОтраженияПрочихОпераций(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	ПроведениеСерверУТ.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) КАК Период,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.АмортизацияОС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	УчетОСВызовСервера.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос, ДополнительныеСвойства);
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	Запрос.УстановитьПараметр("Граница", Новый Граница(НачалоМесяца(Реквизиты.Период), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("КонецМесяца", Новый Граница(КонецМесяца(Реквизиты.Период), ВидГраницы.Включая));
	
КонецПроцедуры

#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстОтраженияВРеглУчете() Экспорт
	
	Возврат УчетОСВызовСервера.ТекстОтраженияВРеглУчетеНачисленнойАмортизации();
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламентированном учете
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	Возврат УчетОСВызовСервера.ТекстЗапросаВТОтраженияВРеглУчетеНачисленнойАмортизации("АмортизацияОС");
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	УчетОСВызовСервера.ЗаполнитьВходящиеДанныеАмортизации(ВходящиеДанные);
	
	ЗакрытиеМесяцаУТВызовСервера.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
