﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Сотрудник") Тогда
		ОбъектОснование = ДанныеЗаполнения.Сотрудник;
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование, , Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Сотрудник", ОбъектОснование);
		Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДатаСеанса());
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсполнительныйЛист.Ссылка
		|ИЗ
		|	Документ.ИсполнительныйЛист КАК ИсполнительныйЛист
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|		ПО ИсполнительныйЛист.Организация.ГоловнаяОрганизация = ТекущиеКадровыеДанныеСотрудников.ГоловнаяОрганизация
		|			И ИсполнительныйЛист.ФизическоеЛицо = ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо
		|			И (ТекущиеКадровыеДанныеСотрудников.Сотрудник = &Сотрудник)
		|ГДЕ
		|	(ИсполнительныйЛист.ДатаОкончания >= &ДатаОкончания
		|			ИЛИ ИсполнительныйЛист.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
		|	И ИсполнительныйЛист.Проведен";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Количество() = 1 Тогда
				
				Выборка.Следующий();
				ОбъектОснование = Выборка.Ссылка
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ИсполнительныйЛист") Тогда
		ЗаполнитьПоИсполнительномуЛисту(ОбъектОснование);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИзменения, "Объект.ДатаИзменения", Отказ, НСтр("ru='Дата изменения'"), , , Ложь);
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 		= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода		= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	= ?(ЗначениеЗаполнено(ДатаОкончания), ДатаОкончания, ДатаИзменения);
	
	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "ФизическоеЛицо", "Объект"));
		
	ИсполнительныеЛисты.ПроверитьДатуИсполнительногоЛиста(ИсполнительныйЛист, ДатаИзменения, Ссылка, "ДатаИзменения", Отказ);	
		
	Если ВидБазы <> Перечисления.ВидыБазыУдержанияПоИсполнительномуДокументу.ПрожиточныйМинимум Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПрожиточныйМинимум");
	КонецЕсли;
	
	Если СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.ФиксированнойСуммой Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидБазы");
	КонецЕсли;
	
	Если СпособРасчета <> Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.ФиксированнойСуммой Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сумма");
	КонецЕсли;
	
	Если СпособРасчета <> Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Процентом Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Процент");
	КонецЕсли;
	
	Если СпособРасчета <> Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Долей Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Числитель");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Знаменатель");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПлатежныйАгент) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "УдержаниеВознагражденияПлатежногоАгента");
	КонецЕсли;
	
	Если Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Утвердить Тогда 
		ЗарплатаКадрыРасширенный.ПроверитьПериодРегистратораНачисленийУдержаний(ДатаИзменения, ДатаОкончания, ЭтотОбъект, "ДатаОкончания", Отказ);
	КонецЕсли;
	
	Если Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить Тогда 
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Удержание");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	Если СпособРасчета <> Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.ФиксированнойСуммой Тогда
		Сумма = Неопределено;
	КонецЕсли;
	
	Если СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.ФиксированнойСуммой Тогда
		ВидБазы = Неопределено;
	КонецЕсли;
	
	Если СпособРасчета <> Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Процентом Тогда
		Процент = Неопределено;
	КонецЕсли;
	
	Если СпособРасчета <> Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Долей Тогда
		Числитель = Неопределено;
		Знаменатель = Неопределено;
	КонецЕсли;
	
	Если ВидБазы <> Перечисления.ВидыБазыУдержанияПоИсполнительномуДокументу.Заработок Тогда
		УчитыватьБольничныеЛисты = Неопределено;
	КонецЕсли;
	
	Если ВидБазы <> Перечисления.ВидыБазыУдержанияПоИсполнительномуДокументу.ПрожиточныйМинимум Тогда
		ПрожиточныйМинимум = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация, , , , Истина);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	ДвиженияУдержаний = Новый Структура;
	ДвиженияУдержаний.Вставить("ДанныеПлановыхУдержаний", ДанныеДляПроведения.ПлановыеУдержания);
	
	РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхУдержаний(Движения, ДвиженияУдержаний);
	
	Если ЭтотОбъект.Действие <> Перечисления.ДействияСНачислениямиИУдержаниями.Отменить Тогда
		ИсполнительныеЛисты.ЗарегистрироватьУсловияИсполнительногоЛиста(
			Движения, ДатаИзменения, ИсполнительныйЛист, ДанныеДляПроведения.УсловияИсполнительногоЛиста);
	КонецЕсли;
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация, , , , Истина);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	Если ЗначениеЗаполнено(ИсполнительныйЛист) Тогда
		
		ПолучателиУдержаний = РасчетЗарплатыРасширенный.НоваяТаблицаПолучателиУдержаний();
		НоваяСтрока = ПолучателиУдержаний.Добавить();
		НоваяСтрока.ФизическоеЛицо = ФизическоеЛицо;
		НоваяСтрока.Удержание = УдержаниеВознагражденияПлатежногоАгента;
		НоваяСтрока.Контрагент = ПлатежныйАгент;
		
		РасчетЗарплатыРасширенный.ЗарегистрироватьПолучателяУдержания(ПолучателиУдержаний, Организация, ИсполнительныйЛист);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	// Если удержание отличается от действующего на данный момент удержания по этому документу, 
	// то предыдущее нужно прекратить.
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ИзменениеУсловий.ДатаИзменения КАК Период,
	|	ИзменениеУсловий.ФизическоеЛицо,
	|	ИзменениеУсловий.Организация.ГоловнаяОрганизация КАК Организация,
	|	ИзменениеУсловий.ИсполнительныйЛист КАК ДокументОснование
	|ПОМЕСТИТЬ ВТИзмеренияДаты
	|ИЗ
	|	Документ.ИзменениеУсловийИсполнительногоЛиста КАК ИзменениеУсловий
	|ГДЕ
	|	ИзменениеУсловий.Ссылка = &ДокументСсылка";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеУдержания",
		МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТИзмеренияДаты",
			"ФизическоеЛицо,Организация,ДокументОснование"));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзменениеУсловий.ДатаИзменения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА ИзменениеУсловий.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить)
	|			ТОГДА NULL
	|		КОГДА ИзменениеУсловий.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ИзменениеУсловий.ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ ИзменениеУсловий.ДатаОкончания
	|	КОНЕЦ КАК ДействуетДо,
	|	ИзменениеУсловий.ФизическоеЛицо,
	|	ИзменениеУсловий.Организация.ГоловнаяОрганизация КАК Организация,
	|	ИзменениеУсловий.Удержание,
	|	ИзменениеУсловий.ИсполнительныйЛист КАК ДокументОснование,
	|	0 КАК Размер,
	|	ВЫБОР
	|		КОГДА ИзменениеУсловий.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Используется,
	|	ЛОЖЬ КАК ИспользуетсяПоОкончании
	|ИЗ
	|	Документ.ИзменениеУсловийИсполнительногоЛиста КАК ИзменениеУсловий
	|ГДЕ
	|	ИзменениеУсловий.Ссылка = &ДокументСсылка
	|	И ИзменениеУсловий.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИзменениеУсловий.ДатаИзменения,
	|	ВЫБОР
	|		КОГДА ИзменениеУсловий.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить)
	|			ТОГДА NULL
	|		КОГДА ИзменениеУсловий.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ИзменениеУсловий.ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ ИзменениеУсловий.ДатаОкончания
	|	КОНЕЦ,
	|	ИзменениеУсловий.ФизическоеЛицо,
	|	ИзменениеУсловий.Организация.ГоловнаяОрганизация,
	|	ИзменениеУсловий.УдержаниеВознагражденияПлатежногоАгента,
	|	ИзменениеУсловий.ИсполнительныйЛист,
	|	0,
	|	ВЫБОР
	|		КОГДА ИзменениеУсловий.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ИзменениеУсловийИсполнительногоЛиста КАК ИзменениеУсловий
	|ГДЕ
	|	ИзменениеУсловий.Ссылка = &ДокументСсылка
	|	И ИзменениеУсловий.ПлатежныйАгент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИзменениеУсловий.ДатаИзменения,
	|	NULL,
	|	ИзменениеУсловий.ФизическоеЛицо,
	|	ИзменениеУсловий.Организация.ГоловнаяОрганизация,
	|	ДействующиеУдержания.Удержание,
	|	ИзменениеУсловий.ИсполнительныйЛист,
	|	0,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ИзменениеУсловийИсполнительногоЛиста КАК ИзменениеУсловий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПлановыеУдержанияСрезПоследних КАК ДействующиеУдержания
	|		ПО (ДействующиеУдержания.Удержание <> ИзменениеУсловий.Удержание)
	|			И (ДействующиеУдержания.Удержание.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист))
	|			И (ИзменениеУсловий.Ссылка = &ДокументСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИзменениеУсловий.ДатаИзменения,
	|	NULL,
	|	ИзменениеУсловий.ФизическоеЛицо,
	|	ИзменениеУсловий.Организация.ГоловнаяОрганизация,
	|	ДействующиеУдержания.Удержание,
	|	ИзменениеУсловий.ИсполнительныйЛист,
	|	0,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ИзменениеУсловийИсполнительногоЛиста КАК ИзменениеУсловий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПлановыеУдержанияСрезПоследних КАК ДействующиеУдержания
	|		ПО (ДействующиеУдержания.Удержание <> ИзменениеУсловий.УдержаниеВознагражденияПлатежногоАгента)
	|			И (ДействующиеУдержания.Удержание.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента))
	|			И (ИзменениеУсловий.Ссылка = &ДокументСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИзменениеУсловий.СпособРасчета,
	|	ИзменениеУсловий.ВидБазы,
	|	ИзменениеУсловий.Процент,
	|	ИзменениеУсловий.Сумма,
	|	ИзменениеУсловий.Числитель,
	|	ИзменениеУсловий.Знаменатель,
	|	ИзменениеУсловий.ПрожиточныйМинимум,
	|	ИзменениеУсловий.Предел,
	|	ИзменениеУсловий.УчитыватьБольничныеЛисты,
	|	ИзменениеУсловий.ИсполнительныйЛист.Получатель КАК Получатель,
	|	ИзменениеУсловий.ПлатежныйАгент,
	|	ИзменениеУсловий.ТарифПлатежногоАгента
	|ИЗ
	|	Документ.ИзменениеУсловийИсполнительногоЛиста КАК ИзменениеУсловий
	|ГДЕ
	|	ИзменениеУсловий.Ссылка = &ДокументСсылка";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Возврат Новый Структура("ПлановыеУдержания, УсловияИсполнительногоЛиста", 
		РезультатыЗапроса[0].Выгрузить(), ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатыЗапроса[1].Выгрузить()[0]));
	
КонецФункции

Процедура ЗаполнитьПоИсполнительномуЛисту(Основание) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ИсполнительныйЛист.Ссылка КАК ИсполнительныйЛист,
	|	ИсполнительныйЛист.Организация,
	|	ИсполнительныйЛист.ФизическоеЛицо,
	|	ИсполнительныйЛист.ДатаОкончания,
	|	ИсполнительныйЛист.СпособРасчета,
	|	ИсполнительныйЛист.ВидБазы,
	|	ИсполнительныйЛист.Удержание,
	|	ИсполнительныйЛист.Процент,
	|	ИсполнительныйЛист.Сумма,
	|	ИсполнительныйЛист.ДатаОкончания,
	|	ИсполнительныйЛист.Числитель,
	|	ИсполнительныйЛист.Знаменатель,
	|	ИсполнительныйЛист.ПрожиточныйМинимум,
	|	ИсполнительныйЛист.Предел,
	|	ИсполнительныйЛист.УчитыватьБольничныеЛисты,
	|	ИсполнительныйЛист.ПлатежныйАгент,
	|	ИсполнительныйЛист.ТарифПлатежногоАгента,
	|	ИсполнительныйЛист.УдержаниеВознагражденияПлатежногоАгента
	|ИЗ
	|	Документ.ИсполнительныйЛист КАК ИсполнительныйЛист
	|ГДЕ
	|	ИсполнительныйЛист.Ссылка = &ИсполнительныйЛист";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИсполнительныйЛист", Основание);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ФизическоеЛицо,
		|	ТаблицаДокумента.ДатаИзменения КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ИзменениеУсловийИсполнительногоЛиста КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
