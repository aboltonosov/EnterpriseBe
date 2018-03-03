﻿
#Область ПрограммныйИнтерфейс

#Область ПодпискиНаСобытия

// Вызывается из подписки на события ПередЗаписьюКурсовВалют
// Параметры:
//	ДополнительныеСвойства - Структрура - Доп.свойства, необходимые для проведения документа.
//	Движения - КоллекцияДвижений - Коллекция движения текущего регистратора.
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура СчитатьКурсыВалютПередЗаписью(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	// Проверка на ОбменДанными.Загрузка исключена специально, поскольку данный механизм отрабатывает
	// при получении данных в РИБ.
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Курсы.Период    КАК Период,
	|	Курсы.Валюта    КАК Валюта,
	|	Курсы.Курс      КАК Курс,
	|	Курсы.Кратность КАК Кратность
	|ПОМЕСТИТЬ КурсыВалютПередЗаписью
	|ИЗ
	|	РегистрСведений.КурсыВалют КАК Курсы
	|ГДЕ
	|	Курсы.Период = &Период
	|");
	
	ДопСвойства = ДополнительныеСвойства.ДополнительныеСвойства;
	ДопСвойства.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
	Запрос.МенеджерВременныхТаблиц = ДопСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Период", ДополнительныеСвойства.Отбор.Период.Значение);
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Вызывается из подписки на события ПроверитьНеобходимостьПереоценки
// Если изменены курсы валют, то необходимо переоценить денежные и валютные средства,
// и пересчитать взаиморасчеты.
// Параметры:
//	ДополнительныеСвойства - Структрура - Доп.свойства, необходимые для проведения документа.
//	Движения - КоллекцияДвижений - Коллекция движения текущего регистратора.
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура ПроверитьНеобходимостьПереоценки(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	// Проверка ОбменДанными.Загрузка не выполняется, поскольку данный механизм отрабатывает при получении данных в РИБ.
	
	Если ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Период КАК Месяц,
	|	Таблица.Валюта КАК Валюта
	|ПОМЕСТИТЬ ВТИзменения
	|ИЗ
	|	(ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(Курсы.Период, МЕСЯЦ) КАК Период,
	|		Курсы.Валюта КАК Валюта,
	|		Курсы.Курс КАК Курс,
	|		Курсы.Кратность КАК Кратность
	|	ИЗ
	|		РегистрСведений.КурсыВалют КАК Курсы
	|	ГДЕ
	|		Курсы.Период = &Период
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(Курсы.Период, МЕСЯЦ),
	|		Курсы.Валюта,
	|		-Курсы.Курс,
	|		-Курсы.Кратность
	|	ИЗ
	|		КурсыВалютПередЗаписью КАК Курсы) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Валюта
	|
	|ИМЕЮЩИЕ
	|	(СУММА(Таблица.Курс) <> 0
	|		ИЛИ СУММА(Таблица.Кратность) <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТИзменения.Месяц КАК Месяц,
	|	ВТИзменения.Валюта КАК Валюта
	|ИЗ
	|	ВТИзменения КАК ВТИзменения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц,
	|	Валюта";
	
	ДопСвойства = ДополнительныеСвойства.ДополнительныеСвойства;
	Запрос.МенеджерВременныхТаблиц = ДопСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Период", ДополнительныеСвойства.Отбор.Период.Значение);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат; // курсы не изменились.
	КонецЕсли;
	
	// Установка заданий в РС "Задания к распределению расчетов с клиентами"
	// и "Задания к распределению расчетов с поставщиками".
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""ЗаданияКРаспределениюРасчетовСКлиентами""      КАК ИмяРегистраЗаданий,
		|	""НомерЗаданияКРаспределениюРасчетовСКлиентами"" КАК ИмяКонстанты,
		|	Клиенты.АналитикаУчетаПоПартнерам                КАК АналитикаУчетаПоПартнерам,
		|	Клиенты.АналитикаУчетаПоПартнерам.Организация    КАК Организация,
		|	Клиенты.ЗаказКлиента                             КАК ОбъектРасчетов,
		|	&НачалоМесяца                                    КАК Месяц
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК Клиенты
		|ГДЕ
		|	Клиенты.Период МЕЖДУ &НачалоМесяца И &КонецМесяца
		|	И Клиенты.Валюта = &Валюта
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""ЗаданияКРаспределениюРасчетовСПоставщиками""      КАК ИмяРегистраЗаданий,
		|	""НомерЗаданияКРаспределениюРасчетовСПоставщиками"" КАК ИмяКонстанты,
		|	Поставщики.АналитикаУчетаПоПартнерам                КАК АналитикаУчетаПоПартнерам,
		|	Поставщики.АналитикаУчетаПоПартнерам.Организация    КАК Организация,
		|	Поставщики.ЗаказПоставщику                          КАК ОбъектРасчетов,
		|	&НачалоМесяца                                       КАК Месяц
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК Поставщики
		|ГДЕ
		|	Поставщики.Период МЕЖДУ &НачалоМесяца И &КонецМесяца
		|	И Поставщики.Валюта = &Валюта
		|";
		
		Запрос.УстановитьПараметр("Валюта", Выборка.Валюта);
		Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Выборка.Месяц));
		Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(Выборка.Месяц));
		
		ВыборкаРасчетов = Запрос.Выполнить().Выбрать();
		Пока ВыборкаРасчетов.Следующий() Цикл
			Задания = РегистрыСведений[ВыборкаРасчетов.ИмяРегистраЗаданий].СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Задания, ВыборкаРасчетов);
			Задания.НомерЗадания = Константы[ВыборкаРасчетов.ИмяКонстанты].Получить();
			Задания.Записать();
		КонецЦикла;
	КонецЦикла;
	
	Если ДопСвойства.Свойство("ПропуститьПроверкуЗапретаИзменения") Тогда 
		Возврат; // добавили новую валюту, скидывать задания не требуется.
	КонецЕсли;
	
	// Установка заданий в РС "Задания к закрытию месяца".
	МассивОрганизаций = Справочники.Организации.ДоступныеОрганизации();
	НомерЗадания = ЗакрытиеМесяцаУТВызовСервера.ТекущийНомерЗадания();
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТИзменения.Месяц КАК Месяц
	|ИЗ
	|	ВТИзменения КАК ВТИзменения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Для Каждого Организация Из МассивОрганизаций Цикл
			
			НаборЗаданияКЗакрытиюМесяца = РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьНаборЗаписей();
			НаборЗаданияКЗакрытиюМесяца.Отбор.Месяц.Установить(Выборка.Месяц);
			НаборЗаданияКЗакрытиюМесяца.Отбор.Операция.Установить(Перечисления.ОперацииЗакрытияМесяца.ПереоценкаВалютныхСредств);
			НаборЗаданияКЗакрытиюМесяца.Отбор.Организация.Установить(Организация);
			НаборЗаданияКЗакрытиюМесяца.Отбор.Документ.Установить(Неопределено);
			
			ЗаписьЗаданияКЗакрытиюМесяца = НаборЗаданияКЗакрытиюМесяца.Добавить();
			ЗаписьЗаданияКЗакрытиюМесяца.Месяц = Выборка.Месяц;
			ЗаписьЗаданияКЗакрытиюМесяца.Операция = Перечисления.ОперацииЗакрытияМесяца.ПереоценкаВалютныхСредств;
			ЗаписьЗаданияКЗакрытиюМесяца.Организация = Организация;
			ЗаписьЗаданияКЗакрытиюМесяца.НомерЗадания = НомерЗадания;
			
			НаборЗаданияКЗакрытиюМесяца.Записать(Истина);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Производится очистка измерения "Документ" по регистрам "Задания..",
// где в текущих записях используется удаляемый документ.
// Вызывается из подписки на события "ОчиститьЗаданияПередУдалениемДокумента",
// выполняется только в главном узле РИБ.
// Параметры:
//  Источник - ДокументСсылка - Ссылка на удаляемый документ.
//	Отказ - Булево - Признак необходимости прерывания удаления объекта.
//
Процедура ОчиститьЗаданияПередУдалениемДокумента(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Задания.ИмяРегистра               КАК ИмяРегистра,
	|	Задания.Месяц                     КАК Месяц,
	|	Задания.НомерЗадания              КАК НомерЗадания,
	|	Задания.Документ                  КАК Документ,
	|	Задания.Операция                  КАК Операция,
	|	Задания.Организация               КАК Организация,
	|	Задания.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Задания.ОбъектРасчетов            КАК ОбъектРасчетов,
	|	Задания.НомерПакета               КАК НомерПакета,
	|	Задания.Пропускать                КАК ПропускатьПриЗаписи
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		""ЗаданияКРасчетуСебестоимости"" КАК ИмяРегистра,
	|		
	|		Задания.Месяц        КАК Месяц,
	|		Задания.НомерЗадания КАК НомерЗадания,
	|		НЕОПРЕДЕЛЕНО         КАК Документ,
	|		НЕОПРЕДЕЛЕНО         КАК Операция,
	|		Задания.Организация  КАК Организация,
	|		НЕОПРЕДЕЛЕНО         КАК АналитикаУчетаПоПартнерам,
	|		НЕОПРЕДЕЛЕНО         КАК ОбъектРасчетов,
	|		НЕОПРЕДЕЛЕНО         КАК НомерПакета,
	|		ВЫБОР КОГДА НЕ Дубли.Документ ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК            Пропускать
	|	ИЗ
	|		РегистрСведений.ЗаданияКРасчетуСебестоимости КАК Задания
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКРасчетуСебестоимости КАК Дубли
	|		ПО Задания.Месяц = Дубли.Месяц
	|			И Задания.НомерЗадания = Дубли.НомерЗадания
	|			И НЕОПРЕДЕЛЕНО = Дубли.Документ
	|	ГДЕ
	|		Задания.Документ = &Ссылка
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		""ЗаданияКЗакрытиюМесяца"" КАК ИмяРегистра,
	|		
	|		Задания.Месяц        КАК Месяц,
	|		Задания.НомерЗадания КАК НомерЗадания,
	|		НЕОПРЕДЕЛЕНО         КАК Документ,
	|		Задания.Операция     КАК Операция,
	|		Задания.Организация  КАК Организация,
	|		НЕОПРЕДЕЛЕНО         КАК АналитикаУчетаПоПартнерам,
	|		НЕОПРЕДЕЛЕНО         КАК ОбъектРасчетов,
	|		НЕОПРЕДЕЛЕНО                      КАК НомерПакета,
	|		ВЫБОР КОГДА НЕ Дубли.Документ ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК            Пропускать
	|	ИЗ
	|		РегистрСведений.ЗаданияКЗакрытиюМесяца КАК Задания
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКЗакрытиюМесяца КАК Дубли
	|		ПО Задания.Месяц = Дубли.Месяц
	|			И Задания.НомерЗадания = Дубли.НомерЗадания
	|			И НЕОПРЕДЕЛЕНО = Дубли.Документ
	|			И Задания.Операция = Дубли.Операция
	|			И Задания.Организация = Дубли.Организация
	|	ГДЕ
	|		Задания.Документ = &Ссылка
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		""ЗаданияКРаспределениюРасчетовСКлиентами"" КАК ИмяРегистра,
	|		
	|		Задания.Месяц                     КАК Месяц,
	|		Задания.НомерЗадания              КАК НомерЗадания,
	|		НЕОПРЕДЕЛЕНО                      КАК Документ,
	|		НЕОПРЕДЕЛЕНО                      КАК Операция,
	|		Задания.Организация  			  КАК Организация,
	|		Задания.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|		Задания.ОбъектРасчетов            КАК ОбъектРасчетов,
	|		НЕОПРЕДЕЛЕНО                      КАК НомерПакета,
	|		ВЫБОР КОГДА Задания.ОбъектРасчетов = &Ссылка ИЛИ НЕ Дубли.Документ ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ                             КАК Пропускать
	|	ИЗ
	|		РегистрСведений.ЗаданияКРаспределениюРасчетовСКлиентами КАК Задания
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКРаспределениюРасчетовСКлиентами КАК Дубли
	|		ПО Задания.Месяц = Дубли.Месяц
	|			И Задания.НомерЗадания = Дубли.НомерЗадания
	|			И НЕОПРЕДЕЛЕНО = Дубли.Документ
	|			И Задания.АналитикаУчетаПоПартнерам = Дубли.АналитикаУчетаПоПартнерам
	|			И Задания.ОбъектРасчетов = Дубли.ОбъектРасчетов
	|	ГДЕ
	|		Задания.Документ = &Ссылка
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		""ЗаданияКРаспределениюРасчетовСПоставщиками"" КАК ИмяРегистра,
	|		
	|		Задания.Месяц                     КАК Месяц,
	|		Задания.НомерЗадания              КАК НомерЗадания,
	|		НЕОПРЕДЕЛЕНО                      КАК Документ,
	|		НЕОПРЕДЕЛЕНО                      КАК Операция,
	|		Задания.Организация  			  КАК Организация,
	|		Задания.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|		Задания.ОбъектРасчетов            КАК ОбъектРасчетов,
	|		НЕОПРЕДЕЛЕНО                      КАК НомерПакета,
	|		ВЫБОР КОГДА Задания.ОбъектРасчетов = &Ссылка ИЛИ НЕ Дубли.Документ ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ                             КАК Пропускать
	|	ИЗ
	|		РегистрСведений.ЗаданияКРаспределениюРасчетовСПоставщиками КАК Задания
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКРаспределениюРасчетовСПоставщиками КАК Дубли
	|		ПО Задания.Месяц = Дубли.Месяц
	|			И Задания.НомерЗадания = Дубли.НомерЗадания
	|			И НЕОПРЕДЕЛЕНО = Дубли.Документ
	|			И Задания.АналитикаУчетаПоПартнерам = Дубли.АналитикаУчетаПоПартнерам
	|			И Задания.ОбъектРасчетов = Дубли.ОбъектРасчетов
	|	ГДЕ
	|		Задания.Документ = &Ссылка
	|
	//++ НЕ УТ
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		""ЗаданияКПогашениюСтоимостиТМЦВЭксплуатации"" КАК ИмяРегистра,
	|		
	|		Задания.Месяц                     КАК Месяц,
	|		Задания.НомерЗадания              КАК НомерЗадания,
	|		НЕОПРЕДЕЛЕНО                      КАК Документ,
	|		НЕОПРЕДЕЛЕНО                      КАК Операция,
	|		Задания.Организация               КАК Организация,
	|		НЕОПРЕДЕЛЕНО                      КАК АналитикаУчетаПоПартнерам,
	|		НЕОПРЕДЕЛЕНО                      КАК ОбъектРасчетов,
	|		Задания.НомерПакета               КАК НомерПакета,
	|		ВЫБОР КОГДА НЕ Дубли.Документ ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ                             КАК Пропускать
	|	ИЗ
	|		РегистрСведений.ЗаданияКПогашениюСтоимостиТМЦВЭксплуатации КАК Задания
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКПогашениюСтоимостиТМЦВЭксплуатации КАК Дубли
	|		ПО Задания.Месяц = Дубли.Месяц
	|			И Задания.НомерЗадания = Дубли.НомерЗадания
	|			И НЕОПРЕДЕЛЕНО = Дубли.Документ
	|			И Задания.НомерПакета = Дубли.НомерПакета
	|			И Задания.Организация = Дубли.Организация
	|	ГДЕ
	|		Задания.Документ = &Ссылка
	//-- НЕ УТ
	|	) КАК Задания
	|ИТОГИ ПО
	|	Задания.ИмяРегистра
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
	ВыборкаЗаданий = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЗаданий.Следующий() Цикл
		ЗаданияКОчистке = РегистрыСведений[ВыборкаЗаданий.ИмяРегистра].СоздатьНаборЗаписей();
		ЗаданияКОчистке.Отбор.Документ.Установить(Источник.Ссылка);
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(ЗаданияКОчистке, Истина);
		
		ЗаданияКЗаписи = РегистрыСведений[ВыборкаЗаданий.ИмяРегистра].СоздатьНаборЗаписей();
		ВыборкаЗаписей = ВыборкаЗаданий.Выбрать();
		Пока ВыборкаЗаписей.Следующий() Цикл 
			Если Не ВыборкаЗаписей.ПропускатьПриЗаписи Тогда
				КЗаписи = ЗаданияКЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(КЗаписи, ВыборкаЗаписей);
			КонецЕсли;
		КонецЦикла;
		Попытка
			Если ЗаданияКЗаписи.Количество() <> 0 Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(ЗаданияКЗаписи, Ложь);
			КонецЕсли;
		Исключение
			Отказ = Истина;
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Удаление помеченных объектов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.ОбщиеМодули.ЗакрытиеМесяцаУТВызовСервера,
				,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
